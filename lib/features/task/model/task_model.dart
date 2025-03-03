import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:task_manager/utils/enums/task_priority.dart';
import 'package:task_manager/utils/enums/task_category.dart';
import 'package:task_manager/utils/enums/task_status.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    int? id,
    required String uniqueId,
    required String title,
    required String description,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'due_date') String? dueDate,
    required TaskPriority priority,
    required TaskStatus status,
    required TaskCategory category,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @Default([]) List<SubTask> subtasks,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}

@freezed
class SubTask with _$SubTask {
  const factory SubTask({
    required String id,
    required String title,
     int? isCompleted,
  }) = _SubTask;

  factory SubTask.fromJson(Map<String, dynamic> json) =>
      _$SubTaskFromJson(json);
}
