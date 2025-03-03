import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/features/task/cubit/tasks_cubit.dart';
import 'package:task_manager/features/task/model/task_model.dart';
import 'package:task_manager/utils/enums/task_priority.dart';

class Priority extends StatefulWidget {
  const Priority({super.key, required this.task});
  final TaskModel task;

  @override
  State<Priority> createState() => _PriorityState();
}

class _PriorityState extends State<Priority> {
  late TaskPriority currentPriority;

  @override
  void initState() {
    super.initState();
    // Convert the task.status (which is a string) back to TaskStatus enum.
    currentPriority = TaskPriority.fromString(widget.task.priority.toReadableString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            // Display the current status using its readable string.
            
            
            Text(
              currentPriority.toReadableString(),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<TaskPriority>(
              icon: SvgPicture.asset(
                'assets/icons/edit.svg',
                height: 20,
                width: 20,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              onSelected: (TaskPriority newStatus) {
                setState(() {
                  currentPriority = newStatus;
                });
                context.read<TasksCubit>().updateTaskPriority(
                      taskId: widget.task.uniqueId,
                      priority: newStatus.name,
                    );
              },
              itemBuilder: (BuildContext context) {
                return TaskPriority.values.map((TaskPriority priority) {
                  return PopupMenuItem<TaskPriority>(
                    value: priority,
                    child: Text(priority.toReadableString()),
                  );
                }).toList();
              },
            ),
          ],
        ),
      ],
    );
  }
}
