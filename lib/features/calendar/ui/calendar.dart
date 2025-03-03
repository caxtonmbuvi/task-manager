import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:task_manager/features/calendar/cubit/calendar_cubit.dart';
import 'package:task_manager/features/calendar/cubit/calendar_state.dart';
import 'package:task_manager/features/task/cubit/tasks_cubit.dart';
import 'package:task_manager/features/task/model/task_model.dart';
import 'package:task_manager/features/task/ui/task_detail.dart';
import 'package:task_manager/utils/global_functions/global_functions.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final int _dayRange = 365;
  bool _isInitialScrollDone = false;

  static const int startHour = 6;
  static const int endHour = 22;
  static const double hourHeight = 60;

  @override
  void initState() {
    super.initState();
    // Scroll to the selected date once the widget builds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final calendarCubit = context.read<CalendarCubit>();
      _scrollToSelectedDate(calendarCubit.state.selectedDate);
    });
  }

  /// Scrolls the horizontal date list to the [selectedDate].
  void _scrollToSelectedDate(DateTime selectedDate) {
    final startDate = DateTime.now().subtract(Duration(days: _dayRange));
    final difference = selectedDate.difference(startDate).inDays;
    final index = difference.clamp(0, (_dayRange * 2 + 1) - 1);
    _itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  /// Opens a date picker dialog.
  Future<void> _pickDate(BuildContext context, CalendarState state) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: state.selectedDate,
      firstDate: DateTime.now().subtract(Duration(days: _dayRange)),
      lastDate: DateTime.now().add(Duration(days: _dayRange)),
    );
    if (picked != null && !_isSameDay(picked, state.selectedDate)) {
      context.read<CalendarCubit>().selectDate(picked);
      _scrollToSelectedDate(picked);
    }
  }

  /// Returns true if the two dates fall on the same day.
  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  /// Builds task widgets for the timeline by positioning them according to start time.
  Widget _buildTaskWidgets(CalendarState state) {
    List<Widget> taskWidgets = [];
    // The tasks list is assumed to be filtered by the selected date.
    for (final TaskModel task in state.tasks) {
      if (task.startDate == null || task.dueDate == null) continue;
      final startTime = DateTime.tryParse(task.startDate!);
      final endTime = DateTime.tryParse(task.dueDate!);
      if (startTime == null || endTime == null) continue;

      // Compute the vertical position and height based on the task's start time and duration.
      // Compute the vertical position and height based on the task's start time and duration.
      final taskStartHour = startTime.hour + startTime.minute / 60.0;
      final topPosition = (taskStartHour - startHour) * hourHeight;
      final durationInHours = endTime.difference(startTime).inMinutes / 60.0;
      final rawTaskHeight = durationInHours * hourHeight;

// Define minimum and maximum task heights.
      const double minTaskHeight = 30.0;
      const double maxTaskHeight =
          180.0; // For example, max height equals 3 hours.

// Clamp the calculated height to be within these bounds.
      final adjustedTaskHeight =
          rawTaskHeight.clamp(minTaskHeight, maxTaskHeight);

      taskWidgets.add(
        Positioned(
          top: topPosition,
          left: 5,
          right: 5,
          height: adjustedTaskHeight,
          child: GestureDetector(
            onTap: () {
              context.read<TasksCubit>().fetchTaskById(taskId: task.uniqueId);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetail(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: GlobalFunctions()
                    .getStatusColor(task.status)
                    .withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8),
              // Optionally, wrap content in a scrollable widget to handle tasks that hit the max height.
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      task.description,
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${DateFormat.jm().format(startTime)} - ${DateFormat.jm().format(endTime)}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Stack(children: taskWidgets);
  }

  /// Builds a single date column for the horizontal date list.
  Widget _buildDateColumn({
    required String weekDay,
    required int dateNumber,
    required bool isActive,
  }) {
    return Container(
      decoration: isActive
          ? BoxDecoration(
              color: Colors.blue.shade500,
              borderRadius: BorderRadius.circular(10),
            )
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      width: 50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weekDay,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            dateNumber.toString(),
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void selectCalendarDate(DateTime date) {
    context.read<CalendarCubit>().selectDate(date);
    _scrollToSelectedDate(date);
  }

  void selectTodayDate() {
    final today = DateTime.now();
    context.read<CalendarCubit>().resetToToday();
    _scrollToSelectedDate(today);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        if (!_isInitialScrollDone) {
          _isInitialScrollDone = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToSelectedDate(state.selectedDate);
          });
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top row: Current Month/Year and "Today" button.
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: theme.dividerColor),
                      const SizedBox(width: 10),
                      RichText(
                        text: TextSpan(
                          text: DateFormat.MMM().format(state.focusedDate),
                          style: theme.textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 20),
                          children: [
                            TextSpan(
                              text: ' ${state.focusedDate.year}',
                              style: theme.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.normal, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: selectTodayDate,
                    child: Text(
                      'Today',
                      style: theme.textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            // Horizontal date selector and date picker.
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 80,
              child: Row(
                children: [
                  Expanded(
                    child: ScrollablePositionedList.builder(
                      itemCount: _dayRange * 2 + 1,
                      scrollDirection: Axis.horizontal,
                      itemScrollController: _itemScrollController,
                      itemBuilder: (context, index) {
                        final startDate =
                            DateTime.now().subtract(Duration(days: _dayRange));
                        final date = startDate.add(Duration(days: index));
                        return GestureDetector(
                          onTap: () => selectCalendarDate(date),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: _buildDateColumn(
                              weekDay: DateFormat.E().format(date),
                              dateNumber: date.day,
                              isActive: _isSameDay(date, state.selectedDate),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.blue),
                    onPressed: () => _pickDate(context, state),
                  ),
                ],
              ),
            ),
            // Main area: Time labels and tasks timeline.
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Time labels column.
                        SizedBox(
                          width: 60,
                          child: Column(
                            children: List.generate(
                              endHour - startHour + 1,
                              (index) => Container(
                                height: hourHeight,
                                alignment: Alignment.topCenter,
                                child: Text(
                                  '${startHour + index}:00',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Tasks timeline.
                        Expanded(
                          child: SizedBox(
                            height: (endHour - startHour + 1) * hourHeight,
                            child: Stack(
                              children: [
                                // Hourly background lines.
                                Column(
                                  children: List.generate(
                                    endHour - startHour + 1,
                                    (index) => Container(
                                      height: hourHeight,
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                              color: Colors.grey.shade300,
                                              width: 0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Task widgets.
                                _buildTaskWidgets(state),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Optional: Loading indicator.
                  if (state.taskStatus.isLoading)
                    const Center(child: CircularProgressIndicator()),
                  // Optional: Error message overlay.
                  if (state.taskStatus.failed)
                    Positioned(
                      top: 20,
                      left: 20,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.white),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                state.taskStatus.failureMessage ?? 'Error',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.white),
                              onPressed: () => context
                                  .read<CalendarCubit>()
                                  .fetchTasksForDate(state.selectedDate),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
