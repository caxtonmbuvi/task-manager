import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:task_manager/features/task/model/task_model.dart';
import 'package:task_manager/utils/app_constants/appconstants.dart';
import 'package:task_manager/utils/services/database_helper.dart';

// // Assuming flutterLocalNotificationsPlugin is already defined and initialized.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class TasksRepo {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  /// Fetch tasks with pagination.
  Future<List<TaskModel>> fetchTasks({int offset = 0, int limit = 20}) async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.tasksTable,
      orderBy: 'updated_at DESC',
      limit: limit,
      offset: offset,
    );
    log('Tasks: $maps');
    return maps.map((json) => TaskModel.fromJson(json)).toList();
  }

  /// Fetch a task by its unique ID.
  Future<List<TaskModel>> fetchTaskById({required String id}) async {
    final taskMaps =
        await databaseHelper.selectById(AppConstants.tasksTable, id: id);
    List<TaskModel> tasks = [];
    for (final map in taskMaps) {
      TaskModel task = TaskModel.fromJson(map);
      // Fetch subtasks for this task.
      final subtaskMaps = await databaseHelper
          .selectById(AppConstants.subtasksTable, id: task.uniqueId);
      log('Sub tasks here: $subtaskMaps');
      final subtasks =
          subtaskMaps.map((subMap) => SubTask.fromJson(subMap)).toList();
      task = task.copyWith(subtasks: subtasks);
      tasks.add(task);
    }
    return tasks;
  }

  /// Fetch local tasks that have not yet been synced (isSynced == 0).
  /// Fetch local tasks that have not yet been synced (isSynced == 0).
  Future<List<TaskModel>> fetchUnsyncedTasks() async {
    final db = await databaseHelper.database;
    final maps = await db.query(
      AppConstants.tasksTable,
      where: 'isSynced = ?',
      whereArgs: [0],
    );
    List<TaskModel> tasks = [];
    for (final map in maps) {
      TaskModel task = TaskModel.fromJson(map);
      final subtaskMaps = await databaseHelper
          .selectById(AppConstants.subtasksTable, id: task.uniqueId);
      final subtasks =
          subtaskMaps.map((subMap) => SubTask.fromJson(subMap)).toList();
      task = task.copyWith(subtasks: subtasks);
      tasks.add(task);
    }
    return tasks;
  }

  Future<List<TaskModel>> fetchTasksByStartDate(DateTime selectedDate,
      {int offset = 0, int limit = 20}) async {
    final db = await databaseHelper.database;
    // Format the date to 'yyyy-MM-dd'
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate.toLocal());
    final maps = await db.query(
      AppConstants.tasksTable,
      where: "date(start_date) = ?",
      whereArgs: [dateStr],
      orderBy: 'updated_at DESC',
      limit: limit,
      offset: offset,
    );
    log('Tasks for $dateStr: $maps');
    return maps.map((json) => TaskModel.fromJson(json)).toList();
  }

  /// Insert a new task.
  Future<void> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    List<SubTask> subtasks = data['subtasks'];

    data.remove('subtasks');
    final id = await databaseHelper.insert(AppConstants.tasksTable, data);

    if (id >= 0) {
      await insertSubtasks(
        data['uniqueId'],
        subtasks.map((s) => s.toJson()).toList(),
      );
    }
  }

  Future<void> insertSubtasks(
      String taskId, List<Map<String, dynamic>> subtasksData) async {
    for (final subtaskData in subtasksData) {
      // Ensure the subtask includes the parent taskId.
      subtaskData['uniqueId'] = taskId;
      await databaseHelper.insert(AppConstants.subtasksTable, subtaskData);
    }
  }

  /// Update an existing task.
  Future<int> updateTask(String id, Map<String, dynamic> taskData) async {
    final subtasks = taskData['subtasks'];

    if (taskData['subtasks'] != null) {
      taskData.remove('subtasks');
    }
    final newId = await databaseHelper.updateTask(id, taskData);
    if (subtasks != null) {
      updateSubTask(id, subtasks);
    }
    return newId;
  }

  /// Update an existing task.
  Future<void> updateSubTask(
    String id,
    List<Map<String, dynamic>> subtasksData,
  ) async {
    try {
      for (final subTask in subtasksData) {
        subTask.remove('id');
        log('Single Sub tasks in edit: $subTask');
        await databaseHelper.update(AppConstants.subtasksTable, id, subTask);
      }
    } catch (e) {
      log('Error here: $e');
    }
  }

  /// Update an existing task.
  Future<int> updateTaskStatus(
      {required String id, required String status}) async {
    return await databaseHelper.updateTaskStatus(id, status);
  }

  Future<int> updateTaskPriority(
      {required String id, required String priority}) async {
    return await databaseHelper.updateTaskPriority(id, priority);
  }

  Future<List<TaskModel>> fetchTasksWithFilters({
    DateTime? date,
    String? status,
    int offset = 0,
    int limit = 20,
  }) async {
    final db = await databaseHelper.database;
    final List<String> conditions = [];
    final List<dynamic> args = [];

    if (date != null) {
      // Format date to 'yyyy-MM-dd'
      final dateStr = DateFormat('yyyy-MM-dd').format(date.toLocal());
      conditions.add("date(start_date) = ?");
      args.add(dateStr);
    }
    if (status != null && status.isNotEmpty) {
      conditions.add("status = ?");
      args.add(status);
    }

    final whereClause = conditions.isNotEmpty ? conditions.join(" AND ") : null;

    final maps = await db.query(
      AppConstants.tasksTable,
      where: whereClause,
      whereArgs: args,
      orderBy: 'updated_at DESC',
      limit: limit,
      offset: offset,
    );
    log('Tasks with filters (date: $date, status: $status): $maps');
    return maps.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<void> scheduleTaskNotification(TaskModel task) async {
    // Parse the due date string and convert to local time.
    final dueDate = DateTime.tryParse(task.dueDate ?? '')?.toLocal();
    if (dueDate == null) return;

    // Only schedule if the due date is in the future.
    if (dueDate.isAfter(DateTime.now())) {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'task_channel_id',
        'Task Reminders',
        channelDescription: 'Notifications for upcoming task deadlines',
        importance: Importance.max,
        priority: Priority.high,
      );

      // For iOS (or macOS), use DarwinNotificationDetails.
      const DarwinNotificationDetails darwinDetails =
          DarwinNotificationDetails();

      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      final reminderTime = dueDate.subtract(Duration(minutes: 2));
      if (reminderTime.isAfter(DateTime.now())) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          task.id ?? 0,
          'Task Reminder',
          'Your task "${task.title}" is due at ${DateFormat.jm().format(dueDate)}.',
          tz.TZDateTime.from(reminderTime, tz.local),
          platformDetails,
          payload: task.uniqueId.toString(),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
  }
}
