import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/features/task/cubit/tasks_cubit.dart';
import 'package:task_manager/features/task/cubit/tasks_state.dart';
import 'package:task_manager/features/task/model/task_model.dart';
import 'package:task_manager/features/task/repo/tasks_repo.dart';
import 'package:task_manager/features/task/ui/widgets/calendar_picker_dialog.dart';
import 'package:task_manager/features/task/ui/widgets/custom_time_picker_dialog.dart';
import 'package:task_manager/utils/app_constants/appconstants.dart';
import 'package:task_manager/utils/enums/task_priority.dart';
import 'package:task_manager/utils/enums/task_category.dart';
import 'package:task_manager/utils/enums/task_status.dart';
import 'package:task_manager/utils/global_functions/global_functions.dart';
import 'package:task_manager/utils/services/sync_service.dart';
import 'package:task_manager/utils/widgets/custom_button.dart';
import 'package:task_manager/utils/widgets/custom_textfield.dart';
import 'package:task_manager/utils/widgets/themed_page.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key, required this.task});
  final TaskModel? task;

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool _isInitialized = false;
  final _formKey = GlobalKey<FormState>();
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  // Controllers for subtask inputs.
  final List<TextEditingController> _subtaskControllers = [];
  // final List<SubtaskEdit> _subtaskEdits = [];

  TaskCategory? selectedCategory;
  DateTime today = DateTime.now();
  DateTime? startDate;
  TimeOfDay? startTime;
  DateTime? endDate;
  TimeOfDay? endTime;
  String? _errorMessage;

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller, {
    required bool isStartDate,
  }) async {
    final selectedDate = await showDialog<DateTime>(
      context: context,
      builder: (context) => CalendarPickerDialog(
        startDate: isStartDate ? today : (startDate ?? today),
        endDate: DateTime(2100),
        busyTimes: const [],
      ),
    );
    if (selectedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = selectedDate;
          // Clear end date if start date is reselected.
          endDate = null;
          _startDateController.text =
              DateFormat('dd MMM yyyy').format(startDate!);
          _endDateController.text = '';
        } else {
          endDate = selectedDate;
          _endDateController.text = DateFormat('dd MMM yyyy').format(endDate!);
        }
      });
      _validateSelections();
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TextEditingController controller, {
    required bool isStartTime,
  }) async {
    final selectedTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) => const CustomTimePickerDialog(),
    );
    if (selectedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = selectedTime;
          _startTimeController.text = selectedTime.format(context);
        } else {
          endTime = selectedTime;
          _endTimeController.text = selectedTime.format(context);
        }
      });
      _validateSelections();
    }
  }

  void _validateSelections() {
    setState(() {
      _errorMessage = null;
      if (startDate == null || startTime == null) {
        _errorMessage = 'Please select both Start Date and Start Time';
        return;
      }
      if (endDate == null || endTime == null) {
        _errorMessage = 'Please select both End Date and End Time';
        return;
      }
      final startDateTime = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        startTime!.hour,
        startTime!.minute,
      );
      final endDateTime = DateTime(
        endDate!.year,
        endDate!.month,
        endDate!.day,
        endTime!.hour,
        endTime!.minute,
      );
      if (endDate!.isBefore(startDate!)) {
        _errorMessage = 'End Date must be after Start Date';
        return;
      }
      if (endDateTime.isBefore(startDateTime)) {
        _errorMessage = 'End Time must be after Start Time';
        return;
      }
      const int minDurationInMinutes = 15;
      if (endDateTime.difference(startDateTime).inMinutes <
          minDurationInMinutes) {
        _errorMessage =
            'Task duration should be at least $minDurationInMinutes minutes';
        return;
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized && widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      if (widget.task!.startDate != null) {
        DateTime parsedStart = DateTime.parse(widget.task!.startDate!);
        startDate = parsedStart;
        startTime =
            TimeOfDay(hour: parsedStart.hour, minute: parsedStart.minute);
        _startDateController.text =
            DateFormat('dd MMM yyyy').format(parsedStart);
        _startTimeController.text = startTime!.format(context);
      }
      if (widget.task!.dueDate != null) {
        DateTime parsedEnd = DateTime.parse(widget.task!.dueDate!);
        endDate = parsedEnd;
        endTime = TimeOfDay(hour: parsedEnd.hour, minute: parsedEnd.minute);
        _endDateController.text = DateFormat('dd MMM yyyy').format(parsedEnd);
        _endTimeController.text = endTime!.format(context);
      }
      try {
        selectedCategory = TaskCategory.values.firstWhere(
          (cat) =>
              cat.name.toLowerCase() ==
              widget.task!.category.name.toLowerCase(),
        );
      } catch (e) {
        selectedCategory = null;
      }
      // Initialize subtask controllers if editing an existing task.
      if (widget.task!.subtasks.isNotEmpty) {
        for (var subtask in widget.task!.subtasks) {
          _subtaskControllers.add(TextEditingController(text: subtask.title));
        }
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    for (var controller in _subtaskControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedPage(
      centerTitle: true,
      appBar: AppBar(
        title: Text(widget.task != null ? 'Edit Task' : 'Create New Task'),
      ),
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.close,
          size: 24,
          color: Theme.of(context).dividerColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: BlocConsumer<TasksCubit, TasksState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.task != null
                                ? 'Edit Task'
                                : 'Create New Task',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontSize: 25,
                                ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Name',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          CustomTextField(controller: _titleController),
                          const SizedBox(height: 15),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          CustomTextField(
                            maxLines: null,
                            minLines: 4,
                            controller: _descriptionController,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'Start Date & Time',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _startDateController,
                                  hintText: 'Pick a date',
                                  suffixIcon:
                                      const Icon(Icons.calendar_month_outlined),
                                  onTap: () => _selectDate(
                                    context,
                                    _startDateController,
                                    isStartDate: true,
                                  ),
                                  readOnly: true,
                                  validator: startDateValidator,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  controller: _startTimeController,
                                  hintText: 'Pick a time',
                                  suffixIcon: const Icon(Icons.timer),
                                  onTap: () => _selectTime(
                                    context,
                                    _startTimeController,
                                    isStartTime: true,
                                  ),
                                  readOnly: true,
                                  validator: startTimeValidator,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            'End Date & Time',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  controller: _endDateController,
                                  hintText: 'Pick a date',
                                  suffixIcon:
                                      const Icon(Icons.calendar_month_outlined),
                                  onTap: () => _selectDate(
                                    context,
                                    _endDateController,
                                    isStartDate: false,
                                  ),
                                  readOnly: true,
                                  validator: dueDateValidator,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: CustomTextField(
                                  controller: _endTimeController,
                                  hintText: 'Pick a time',
                                  suffixIcon: const Icon(Icons.timer),
                                  onTap: () => _selectTime(
                                    context,
                                    _endTimeController,
                                    isStartTime: false,
                                  ),
                                  readOnly: true,
                                  validator: endTimeValidator,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          if (_errorMessage != null)
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          const SizedBox(height: 15),
                          Text(
                            'Category',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 15),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: TaskCategory.values.map((category) {
                              final isSelected = category == selectedCategory;
                              return ChoiceChip(
                                label: Text(
                                  category.name.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                                selected: isSelected,
                                backgroundColor: Colors.grey[300],
                                selectedColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onSelected: (bool selected) {
                                  setState(() {
                                    selectedCategory =
                                        selected ? category : null;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 15),
                          // --- Subtasks Section ---
                          Text(
                            'Subtasks',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: List.generate(_subtaskControllers.length,
                                (index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        key: ValueKey(_subtaskControllers[index]),
                                        controller: _subtaskControllers[index],
                                        hintText: 'Enter subtask',
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          _subtaskControllers.removeAt(index);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _subtaskControllers
                                    .add(TextEditingController());
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add Subtask'),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    width: double.maxFinite,
                    text: widget.task != null ? 'Update Task' : 'Create Task',
                    onTap: submit,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final combinedStartDateTime = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
        startTime!.hour,
        startTime!.minute,
      );
      final combinedDateString =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(combinedStartDateTime);
      final isoStartString =
          GlobalFunctions().convertDateString(combinedDateString);

      final combinedEndDateTime = DateTime(
        endDate!.year,
        endDate!.month,
        endDate!.day,
        endTime!.hour,
        endTime!.minute,
      );
      final combinedEndDateString =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(combinedEndDateTime);
      final isoEndString =
          GlobalFunctions().convertDateString(combinedEndDateString);

      final subtasks = _subtaskControllers
          .where((controller) => controller.text.trim().isNotEmpty)
          .map((controller) => SubTask(
                id: GlobalFunctions().generateId(),
                title: controller.text.trim(),
                isCompleted: 0,
              ))
          .toList();

      if (widget.task != null) {
        // Update existing task.
        final updatedTaskData = {
          'uniqueId': widget.task!.uniqueId,
          'title': _titleController.text,
          'description': _descriptionController.text,
          'start_date': isoStartString,
          'due_date': isoEndString,
          'priority': TaskPriority.low.name,
          'status': TaskStatus.pending.name,
          'category': selectedCategory!.name,
          'updated_at': DateTime.now().toIso8601String(),
          'subtasks': subtasks.map((s) => s.toJson()).toList(),
        };

        await context
            .read<TasksRepo>()
            .updateTask(widget.task!.uniqueId, updatedTaskData);
        if (mounted) {
          final task = TaskModel(
            uniqueId: widget.task!.uniqueId,
            title: _titleController.text,
            description: _descriptionController.text,
            startDate: isoStartString,
            dueDate: isoEndString,
            priority: TaskPriority.low,
            status: TaskStatus.pending,
            category: selectedCategory!,
            updatedAt: DateTime.now().toIso8601String(),
            subtasks: subtasks,
          );

          if (mounted) unawaited(context.read<SyncService>().syncTask(task));
        }
        if (mounted) {
          await context
              .read<TasksCubit>()
              .fetchTaskById(taskId: widget.task!.uniqueId);
        }
      } else {
        // Create new task.
        final taskData = TaskModel(
          uniqueId: GlobalFunctions().generateId(),
          title: _titleController.text,
          description: _descriptionController.text,
          startDate: isoStartString,
          dueDate: isoEndString,
          priority: TaskPriority.low,
          status: TaskStatus.pending,
          category: selectedCategory!,
          updatedAt: DateTime.now().toIso8601String(),
          subtasks: subtasks,
        );

        await context.read<TasksRepo>().insert(
              table: AppConstants.tasksTable,
              data: taskData.toJson(),
            );

        if (mounted) {
          unawaited(context.read<SyncService>().syncTask(taskData));
          await context.read<TasksRepo>().scheduleTaskNotification(taskData);
        }
      }
      if (mounted) {
        unawaited(context.read<TasksCubit>().fetchTasks(isRefresh: true));
        Navigator.pop(context);
      }
    }
  }

  String? startDateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a start date';
    }
    return null;
  }

  String? startTimeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a start time';
    }
    return null;
  }

  String? endTimeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an end time';
    }
    return null;
  }

  String? dueDateValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }
    if (startDate != null && endDate != null && endDate!.isBefore(startDate!)) {
      return 'End date cannot be before start date';
    }
    return null;
  }
}
