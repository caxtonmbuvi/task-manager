import 'dart:developer';

import 'package:task_manager/features/task/model/task_model.dart';
import 'package:task_manager/features/task/repo/tasks_repo.dart';
import 'package:task_manager/utils/app_constants/appconstants.dart';
import 'firebase_service.dart';

class SyncService {
  final TasksRepo tasksRepo;
  final FirebaseService firebaseService;

  SyncService({required this.tasksRepo, required this.firebaseService});

  /// Sync tasks between Firebase and local storage.
  Future<void> syncTasks() async {
    // 1. Fetch tasks from Firebase (for the current user).
    try {
      List<TaskModel> remoteTasks = await firebaseService.fetchTasks();
      log('Remote tasks: $remoteTasks');
      for (var task in remoteTasks) {
        final localTasks = await tasksRepo.fetchTaskById(id: task.uniqueId);
        if (localTasks.isEmpty) {
          await tasksRepo.insert(table: 'tasks', data: task.toJson());
          for (var subtask in task.subtasks) {
            await tasksRepo.insert(
                table: AppConstants.subtasksTable, data: subtask.toJson());
          }
        } else {
          await tasksRepo.updateTask(task.uniqueId, task.toJson());
          await tasksRepo.updateSubTask(
              task.uniqueId, task.subtasks.map((s) => s.toJson()).toList());
        }
      }
    } catch (e) {
      log('Error: $e');
    }

    // 2. Get unsynced local tasks (isSynced == 0) and push them to Firebase.
    List<TaskModel> unsyncedTasks = await tasksRepo.fetchUnsyncedTasks();
    for (var task in unsyncedTasks) {
      bool uploaded = await firebaseService.uploadTask(task);
      // 2. Now handle the subtasks.
      bool subtasksUploaded = await firebaseService.uploadSubtasks(
        task.uniqueId,
        task.subtasks,
      );
      if (uploaded && subtasksUploaded) {
        await tasksRepo.updateTask(task.uniqueId, {'isSynced': 1});
      }
    }
  }

  Future<void> syncTask(TaskModel task) async {
    bool uploaded = await firebaseService.uploadTask(task);
    bool subtasksUploaded = await firebaseService.uploadSubtasks(
      task.uniqueId,
      task.subtasks,
    );
    if (uploaded && subtasksUploaded) {
      
      await tasksRepo.updateTask(task.uniqueId, {'isSynced': 1});
    }
  }
}
