// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: (json['id'] as num?)?.toInt(),
      uniqueId: json['uniqueId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startDate: json['start_date'] as String?,
      dueDate: json['due_date'] as String?,
      priority: $enumDecode(_$TaskPriorityEnumMap, json['priority']),
      status: $enumDecode(_$TaskStatusEnumMap, json['status']),
      category: $enumDecode(_$TaskCategoryEnumMap, json['category']),
      updatedAt: json['updated_at'] as String?,
      subtasks: (json['subtasks'] as List<dynamic>?)
              ?.map((e) => SubTask.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uniqueId': instance.uniqueId,
      'title': instance.title,
      'description': instance.description,
      'start_date': instance.startDate,
      'due_date': instance.dueDate,
      'priority': _$TaskPriorityEnumMap[instance.priority]!,
      'status': _$TaskStatusEnumMap[instance.status]!,
      'category': _$TaskCategoryEnumMap[instance.category]!,
      'updated_at': instance.updatedAt,
      'subtasks': instance.subtasks,
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.low: 'low',
  TaskPriority.high: 'high',
};

const _$TaskStatusEnumMap = {
  TaskStatus.pending: 'pending',
  TaskStatus.inProgress: 'inProgress',
  TaskStatus.completed: 'completed',
};

const _$TaskCategoryEnumMap = {
  TaskCategory.work: 'work',
  TaskCategory.personal: 'personal',
  TaskCategory.other: 'other',
};

_$SubTaskImpl _$$SubTaskImplFromJson(Map<String, dynamic> json) =>
    _$SubTaskImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: (json['isCompleted'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$SubTaskImplToJson(_$SubTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'isCompleted': instance.isCompleted,
    };
