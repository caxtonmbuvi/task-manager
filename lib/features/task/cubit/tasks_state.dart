import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/features/task/model/task_model.dart';
import 'package:task_manager/utils/models/result.dart';

part 'tasks_state.freezed.dart';

@freezed
class TasksState with _$TasksState {
  const factory TasksState({
    @Default(Result<void>.empty()) Result<void> fetchStatus,
    @Default(Result<void>.empty()) Result<void> fetchDetailStatus,
    @Default(Result<void>.empty()) Result<void> updateTaskStatus,
    @Default([]) List<TaskModel> tasks,
    TaskModel? task,
    @Default(false) bool hasReachedMax,
  }) = _TasksState;
}
