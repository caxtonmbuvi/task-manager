// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tasks_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TasksState {
  Result<void> get fetchStatus => throw _privateConstructorUsedError;
  Result<void> get fetchDetailStatus => throw _privateConstructorUsedError;
  Result<void> get updateTaskStatus => throw _privateConstructorUsedError;
  List<TaskModel> get tasks => throw _privateConstructorUsedError;
  TaskModel? get task => throw _privateConstructorUsedError;
  bool get hasReachedMax => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TasksStateCopyWith<TasksState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TasksStateCopyWith<$Res> {
  factory $TasksStateCopyWith(
          TasksState value, $Res Function(TasksState) then) =
      _$TasksStateCopyWithImpl<$Res, TasksState>;
  @useResult
  $Res call(
      {Result<void> fetchStatus,
      Result<void> fetchDetailStatus,
      Result<void> updateTaskStatus,
      List<TaskModel> tasks,
      TaskModel? task,
      bool hasReachedMax});

  $ResultCopyWith<void, $Res> get fetchStatus;
  $ResultCopyWith<void, $Res> get fetchDetailStatus;
  $ResultCopyWith<void, $Res> get updateTaskStatus;
  $TaskModelCopyWith<$Res>? get task;
}

/// @nodoc
class _$TasksStateCopyWithImpl<$Res, $Val extends TasksState>
    implements $TasksStateCopyWith<$Res> {
  _$TasksStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fetchStatus = null,
    Object? fetchDetailStatus = null,
    Object? updateTaskStatus = null,
    Object? tasks = null,
    Object? task = freezed,
    Object? hasReachedMax = null,
  }) {
    return _then(_value.copyWith(
      fetchStatus: null == fetchStatus
          ? _value.fetchStatus
          : fetchStatus // ignore: cast_nullable_to_non_nullable
              as Result<void>,
      fetchDetailStatus: null == fetchDetailStatus
          ? _value.fetchDetailStatus
          : fetchDetailStatus // ignore: cast_nullable_to_non_nullable
              as Result<void>,
      updateTaskStatus: null == updateTaskStatus
          ? _value.updateTaskStatus
          : updateTaskStatus // ignore: cast_nullable_to_non_nullable
              as Result<void>,
      tasks: null == tasks
          ? _value.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
      task: freezed == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as TaskModel?,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ResultCopyWith<void, $Res> get fetchStatus {
    return $ResultCopyWith<void, $Res>(_value.fetchStatus, (value) {
      return _then(_value.copyWith(fetchStatus: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ResultCopyWith<void, $Res> get fetchDetailStatus {
    return $ResultCopyWith<void, $Res>(_value.fetchDetailStatus, (value) {
      return _then(_value.copyWith(fetchDetailStatus: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ResultCopyWith<void, $Res> get updateTaskStatus {
    return $ResultCopyWith<void, $Res>(_value.updateTaskStatus, (value) {
      return _then(_value.copyWith(updateTaskStatus: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TaskModelCopyWith<$Res>? get task {
    if (_value.task == null) {
      return null;
    }

    return $TaskModelCopyWith<$Res>(_value.task!, (value) {
      return _then(_value.copyWith(task: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TasksStateImplCopyWith<$Res>
    implements $TasksStateCopyWith<$Res> {
  factory _$$TasksStateImplCopyWith(
          _$TasksStateImpl value, $Res Function(_$TasksStateImpl) then) =
      __$$TasksStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Result<void> fetchStatus,
      Result<void> fetchDetailStatus,
      Result<void> updateTaskStatus,
      List<TaskModel> tasks,
      TaskModel? task,
      bool hasReachedMax});

  @override
  $ResultCopyWith<void, $Res> get fetchStatus;
  @override
  $ResultCopyWith<void, $Res> get fetchDetailStatus;
  @override
  $ResultCopyWith<void, $Res> get updateTaskStatus;
  @override
  $TaskModelCopyWith<$Res>? get task;
}

/// @nodoc
class __$$TasksStateImplCopyWithImpl<$Res>
    extends _$TasksStateCopyWithImpl<$Res, _$TasksStateImpl>
    implements _$$TasksStateImplCopyWith<$Res> {
  __$$TasksStateImplCopyWithImpl(
      _$TasksStateImpl _value, $Res Function(_$TasksStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fetchStatus = null,
    Object? fetchDetailStatus = null,
    Object? updateTaskStatus = null,
    Object? tasks = null,
    Object? task = freezed,
    Object? hasReachedMax = null,
  }) {
    return _then(_$TasksStateImpl(
      fetchStatus: null == fetchStatus
          ? _value.fetchStatus
          : fetchStatus // ignore: cast_nullable_to_non_nullable
              as Result<void>,
      fetchDetailStatus: null == fetchDetailStatus
          ? _value.fetchDetailStatus
          : fetchDetailStatus // ignore: cast_nullable_to_non_nullable
              as Result<void>,
      updateTaskStatus: null == updateTaskStatus
          ? _value.updateTaskStatus
          : updateTaskStatus // ignore: cast_nullable_to_non_nullable
              as Result<void>,
      tasks: null == tasks
          ? _value._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<TaskModel>,
      task: freezed == task
          ? _value.task
          : task // ignore: cast_nullable_to_non_nullable
              as TaskModel?,
      hasReachedMax: null == hasReachedMax
          ? _value.hasReachedMax
          : hasReachedMax // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$TasksStateImpl implements _TasksState {
  const _$TasksStateImpl(
      {this.fetchStatus = const Result<void>.empty(),
      this.fetchDetailStatus = const Result<void>.empty(),
      this.updateTaskStatus = const Result<void>.empty(),
      final List<TaskModel> tasks = const [],
      this.task,
      this.hasReachedMax = false})
      : _tasks = tasks;

  @override
  @JsonKey()
  final Result<void> fetchStatus;
  @override
  @JsonKey()
  final Result<void> fetchDetailStatus;
  @override
  @JsonKey()
  final Result<void> updateTaskStatus;
  final List<TaskModel> _tasks;
  @override
  @JsonKey()
  List<TaskModel> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  final TaskModel? task;
  @override
  @JsonKey()
  final bool hasReachedMax;

  @override
  String toString() {
    return 'TasksState(fetchStatus: $fetchStatus, fetchDetailStatus: $fetchDetailStatus, updateTaskStatus: $updateTaskStatus, tasks: $tasks, task: $task, hasReachedMax: $hasReachedMax)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TasksStateImpl &&
            (identical(other.fetchStatus, fetchStatus) ||
                other.fetchStatus == fetchStatus) &&
            (identical(other.fetchDetailStatus, fetchDetailStatus) ||
                other.fetchDetailStatus == fetchDetailStatus) &&
            (identical(other.updateTaskStatus, updateTaskStatus) ||
                other.updateTaskStatus == updateTaskStatus) &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            (identical(other.task, task) || other.task == task) &&
            (identical(other.hasReachedMax, hasReachedMax) ||
                other.hasReachedMax == hasReachedMax));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      fetchStatus,
      fetchDetailStatus,
      updateTaskStatus,
      const DeepCollectionEquality().hash(_tasks),
      task,
      hasReachedMax);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TasksStateImplCopyWith<_$TasksStateImpl> get copyWith =>
      __$$TasksStateImplCopyWithImpl<_$TasksStateImpl>(this, _$identity);
}

abstract class _TasksState implements TasksState {
  const factory _TasksState(
      {final Result<void> fetchStatus,
      final Result<void> fetchDetailStatus,
      final Result<void> updateTaskStatus,
      final List<TaskModel> tasks,
      final TaskModel? task,
      final bool hasReachedMax}) = _$TasksStateImpl;

  @override
  Result<void> get fetchStatus;
  @override
  Result<void> get fetchDetailStatus;
  @override
  Result<void> get updateTaskStatus;
  @override
  List<TaskModel> get tasks;
  @override
  TaskModel? get task;
  @override
  bool get hasReachedMax;
  @override
  @JsonKey(ignore: true)
  _$$TasksStateImplCopyWith<_$TasksStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
