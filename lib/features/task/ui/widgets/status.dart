import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/features/task/cubit/tasks_cubit.dart';
import 'package:task_manager/features/task/model/task_model.dart';
import 'package:task_manager/utils/enums/task_status.dart';

class Status extends StatefulWidget {
  const Status({super.key, required this.task});
  final TaskModel task;

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  late TaskStatus currentStatus;

  @override
  void initState() {
    super.initState();
    // Convert the task.status (which is a string) back to TaskStatus enum.
    currentStatus = TaskStatus.fromString(widget.task.status.toReadableString());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            // Display the current status using its readable string.
            
            
            Text(
              currentStatus.toReadableString(),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<TaskStatus>(
              icon: SvgPicture.asset(
                'assets/icons/edit.svg',
                height: 20,
                width: 20,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
              onSelected: (TaskStatus newStatus) {
                setState(() {
                  currentStatus = newStatus;
                });
                context.read<TasksCubit>().updateTaskStatus(
                      taskId: widget.task.uniqueId,
                      status: newStatus.name,
                    );
              },
              itemBuilder: (BuildContext context) {
                return TaskStatus.values.map((TaskStatus status) {
                  return PopupMenuItem<TaskStatus>(
                    value: status,
                    child: Text(status.toReadableString()),
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
