import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/cubit/tasks_state.dart';
import 'package:task_manager/features/task/model/task_model.dart';
import 'package:task_manager/features/task/repo/tasks_repo.dart';
import 'package:task_manager/utils/models/result.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit({required this.repo}) : super(const TasksState());

  final TasksRepo repo;
  int _offset = 0;
  final int _limit = 20;

  Future<void> fetchTasks({bool isRefresh = false}) async {
    // If already at max and not refreshing, do nothing.
    if (state.hasReachedMax && !isRefresh) return;

    if (isRefresh) {
      _offset = 0;
    }

    try {
      final newTasks = await repo.fetchTasks(offset: _offset, limit: _limit);

      // Determine if we've reached the end of the data.
      final hasReachedMax = newTasks.length < _limit;

      // Create a new list for tasks, ensuring immutability.
      final updatedTasks = isRefresh
          ? List<TaskModel>.from(newTasks) // Fresh list for refresh
          : [...state.tasks, ...newTasks];

      // Emit the updated state.
      emit(state.copyWith(
        tasks: updatedTasks,
        hasReachedMax: hasReachedMax,
        fetchStatus: Result.success(null),
      ));

      // Update the offset for pagination.
      _offset += _limit;
    } catch (error) {
      log('Error: $error');
      emit(state.copyWith(
        fetchStatus: Result.failure(error.toString()),
      ));
    }
  }

  Future<void> fetchTaskById({required String taskId}) async {
    emit(state.copyWith(fetchDetailStatus: Result.loading()));
    try {
      final tasKDetail = await repo.fetchTaskById(id: taskId);
      emit(
        state.copyWith(
          fetchDetailStatus: Result.success(null),
          task: tasKDetail.first,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        fetchDetailStatus: Result.failure(e.toString()),
      ));
    }
  }

  Future<void> updateTaskStatus({
    required String taskId,
    required String status,
  }) async {
    emit(state.copyWith(updateTaskStatus: Result.loading()));
    try {
      await repo.updateTaskStatus(id: taskId, status: status);
      emit(
        state.copyWith(
          updateTaskStatus: Result.success(null),
        ),
      );

      emit(
        state.copyWith(
          updateTaskStatus: Result.empty(),
        ),
      );

      await fetchTaskById(taskId: taskId);
      await fetchTasks(isRefresh: true);
    } catch (e) {
      emit(state.copyWith(
        updateTaskStatus: Result.failure(e.toString()),
      ));
    }
  }


  Future<void> updateTaskPriority({
    required String taskId,
    required String priority,
  }) async {
    emit(state.copyWith(updateTaskStatus: Result.loading()));
    try {
      await repo.updateTaskPriority(id: taskId, priority: priority);
      emit(
        state.copyWith(
          updateTaskStatus: Result.success(null),
        ),
      );

      emit(
        state.copyWith(
          updateTaskStatus: Result.empty(),
        ),
      );

      await fetchTaskById(taskId: taskId);
      await fetchTasks(isRefresh: true);
    } catch (e) {
      emit(state.copyWith(
        updateTaskStatus: Result.failure(e.toString()),
      ));
    }
  }
}
