import 'package:equatable/equatable.dart';
import 'package:task_manager/features/task/model/task_model.dart';
import 'package:task_manager/utils/models/result.dart';

class CalendarState extends Equatable {
  final DateTime selectedDate;
  final DateTime focusedDate;
  final List<TaskModel> tasks;
  final Result taskStatus;

  const CalendarState({
    required this.selectedDate,
    required this.focusedDate,
    required this.tasks,
    required this.taskStatus,
  });

  factory CalendarState.initial() {
    final today = DateTime.now();
    return CalendarState(
      selectedDate: today,
      focusedDate: today,
      tasks: [],
      taskStatus: Result.empty(),
    );
  }

  CalendarState copyWith({
    DateTime? selectedDate,
    DateTime? focusedDate,
    List<TaskModel>? tasks,
    Result? taskStatus,
  }) {
    return CalendarState(
      selectedDate: selectedDate ?? this.selectedDate,
      focusedDate: focusedDate ?? this.focusedDate,
      tasks: tasks ?? this.tasks,
      taskStatus: taskStatus ?? this.taskStatus,
    );
  }

  @override
  List<Object?> get props => [selectedDate, focusedDate, tasks, taskStatus];
}
