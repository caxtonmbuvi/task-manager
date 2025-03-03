import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/features/task/cubit/tasks_cubit.dart';
import 'package:task_manager/features/task/cubit/tasks_state.dart';
import 'package:task_manager/features/task/model/task_model.dart';
import 'package:task_manager/features/task/ui/add_task.dart';
import 'package:task_manager/features/task/ui/widgets/priority.dart';
import 'package:task_manager/features/task/ui/widgets/status.dart';
import 'package:task_manager/utils/global_functions/global_functions.dart';
import 'package:task_manager/utils/snackbar/snackbar.dart';
import 'package:task_manager/utils/widgets/themed_page.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({
    super.key,
  });

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedPage(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Task Detail'),
      ),
      body: BlocConsumer<TasksCubit, TasksState>(
        listener: listener,
        builder: (context, state) {
          if (state.updateTaskStatus.isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state.fetchDetailStatus.failed) {
            return Center(
              child: Text(state.fetchDetailStatus.failureMessage!),
            );
          }

          if (state.fetchDetailStatus.succeeded) {
            final task = state.task!;

            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    GlobalFunctions().getTaskCategoryDisplay(task.category),
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    task.title,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    task.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Status(
                          task: task,
                        ),
                      ),
                      Expanded(
                        child: Priority(
                          task: task,
                        ),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/date.svg',
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                Colors.blue,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(GlobalFunctions().formatDate(task.dueDate!))
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/start-time.svg',
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                Colors.blue,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(GlobalFunctions().formatTime(task.startDate!))
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Divider(),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/end-time.svg',
                              width: 20,
                              colorFilter: ColorFilter.mode(
                                Colors.blue,
                                BlendMode.srcIn,
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(GlobalFunctions().formatTime(task.dueDate!))
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Divider(
                    color: Colors.grey.shade200,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  task.subtasks.isNotEmpty
                      ? Text(
                          'Sub Tasks',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        )
                      : SizedBox.shrink(),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: task.subtasks.length,
                      itemBuilder: (context, index) {
                        final subtask = task.subtasks[index];
                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            subtask.title,
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: BlocBuilder<TasksCubit, TasksState>(
        builder: (context, state) {
          if (state.fetchDetailStatus.succeeded) {
            final task = state.task!;
            return FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () => showFullPagePopup(context, task),
              // onPressed: () => _addRandomTask(),
              // Create a rounded button using a custom shape.
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            );
          }
          return SizedBox.shrink();
        },
      ),
      // Position the FAB at the bottom right.
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void showFullPagePopup(BuildContext context, TaskModel task) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return AddTask(
          task: task,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  void listener(BuildContext context, TasksState state) {
    if (state.updateTaskStatus.succeeded) {
      showTopSnackBar(
        context,
        'Task successsfully updated',
        isSuccess: true,
      );
    }
  }
}
