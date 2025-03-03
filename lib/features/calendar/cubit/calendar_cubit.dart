import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/calendar/cubit/calendar_state.dart';
import 'package:task_manager/features/task/repo/tasks_repo.dart';
import 'package:task_manager/utils/models/result.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit({required this.repo}) : super(CalendarState.initial());

  final TasksRepo repo;

  /// Fetches tasks for a specific [selectedDate] using the repo's fetchTasksByStartDate method.
  Future<void> fetchTasksForDate(DateTime selectedDate) async {
    try {
      // Emit loading state.
      emit(state.copyWith(taskStatus: Result.loading()));

      // Fetch tasks filtered by start date from the repository.
      final tasks = await repo.fetchTasksByStartDate(selectedDate);

      emit(state.copyWith(
        tasks: tasks,
        selectedDate: selectedDate,
        focusedDate: selectedDate,
        taskStatus: Result.success(null),
      ));
    } catch (error) {
      log('Error fetching tasks for date: $error');
      emit(state.copyWith(
        taskStatus: Result.failure(error.toString()),
      ));
    }
  }

  /// Updates the selected date and fetches tasks for that date.
  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date, focusedDate: date));
    fetchTasksForDate(date);
  }

  /// Resets the calendar to today’s date and fetches its tasks.
  void resetToToday() {
    final today = DateTime.now();
    emit(state.copyWith(selectedDate: today, focusedDate: today));
    fetchTasksForDate(today);
  }
}