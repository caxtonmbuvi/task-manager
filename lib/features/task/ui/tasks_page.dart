import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/features/task/cubit/tasks_cubit.dart';
import 'package:task_manager/features/task/cubit/tasks_state.dart';
import 'package:task_manager/features/task/enum/task_status.dart';
import 'package:task_manager/features/task/model/task_model.dart';
import 'package:task_manager/features/task/ui/task_detail.dart';
import 'package:task_manager/utils/enums/task_priority.dart';
import 'package:task_manager/utils/global_functions/global_functions.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  /// `null` will represent "All statuses"
  TaskStatus? _selectedStatusFilter;

  /// `null` will represent "All priorities"
  TaskPriority? _selectedPriorityFilter;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksCubit, TasksState>(
      builder: (context, state) {
        // Show a loading spinner while data is being fetched.
        if (state.fetchStatus.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Display an error message if needed.
        if (state.fetchStatus.failed) {
          return Center(
            child: Text('Error: ${state.fetchStatus.failureMessage}'),
          );
        }

        // Show a message if there are no tasks at all.
        if (state.tasks.isEmpty) {
          return _buildEmptyTasksView(context);
        }

        // Filter tasks based on selected status and priority
        final filteredTasks = _applyFilters(
          state.tasks,
          _selectedStatusFilter,
          _selectedPriorityFilter,
        );

        final tasks = state.tasks;
        final completedCount =
            tasks.where((task) => task.status.name.toLowerCase() == TaskStatus.completed.name.toLowerCase()).length;
        final openCount =
            tasks.where((task) => task.status.name.toLowerCase() == TaskStatus.pending.name.toLowerCase()).length;

        return Column(
          children: [
            // Example "stats" row
            _buildStatsRow(context, completedCount, openCount),

            // --- Filters for Status and Priority ---
            _buildFilterRow(context),

            _buildPriorityRow(context),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${filteredTasks.length}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: '  tasks',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // --- Render Filtered Tasks ---
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return GestureDetector(
                    onTap: () {
                      context
                          .read<TasksCubit>()
                          .fetchTaskById(taskId: task.uniqueId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetail(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: GlobalFunctions().getStatusColor(task.status),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            GlobalFunctions()
                                .getTaskCategoryDisplay(task.category),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                          ),
                          Text(
                            task.title,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            task.description,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .copyWith(color: Colors.black),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                GlobalFunctions().formatDate(task.startDate!),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.black),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Helper method to filter tasks based on selected status & priority
  List<TaskModel> _applyFilters(
    List<TaskModel> tasks,
    TaskStatus? statusFilter,
    TaskPriority? priorityFilter,
  ) {
    return tasks.where((task) {
      final matchesStatus = (statusFilter == null) ||
          (task.status.name.toLowerCase() == statusFilter.name.toLowerCase());
      final matchesPriority =
          (priorityFilter == null) || (task.priority == priorityFilter);
      return matchesStatus && matchesPriority;
    }).toList();
  }

  /// Example of building the top "stats" row
  Widget _buildStatsRow(BuildContext context, int completed, int pending) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      '$completed',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Completed Task',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      '$pending',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Pending Task',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the empty tasks view
  Widget _buildEmptyTasksView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/icons/empty-task..svg',
              width: 120,
              colorFilter: const ColorFilter.mode(
                Colors.blue,
                BlendMode.srcIn,
              ),
            ),
          ),
          Text(
            'You do Not have any Tasks',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'You have no tasks yet, kindly add tasks',
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // ---- PRIORITY FILTERS ----
            // "All"
            _buildPriorityFilterItem(null, 'All Priority'),

            // Show each priority from your enum
            _buildPriorityFilterItem(TaskPriority.low, 'Low'),
            // _buildPriorityFilterItem(TaskPriority.medium, 'Medium'),
            _buildPriorityFilterItem(TaskPriority.high, 'High'),
          ],
        ),
      ),
    );
  }

  /// Build filters row (both Status and Priority)
  Widget _buildFilterRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // ---- STATUS FILTERS ----
            // "All"
            _buildStatusFilterItem(null, 'All'),

            // Show each status from your enum
            _buildStatusFilterItem(TaskStatus.pending, 'Pending'),
            _buildStatusFilterItem(TaskStatus.inprogress, 'In Progress'),
            // _buildStatusFilterItem(TaskStatus.onHold, 'On Hold'),
            _buildStatusFilterItem(TaskStatus.completed, 'Completed'),
            // _buildStatusFilterItem(TaskStatus.cancelled, 'Cancelled'),
          ],
        ),
      ),
    );
  }

  /// Single filter 'chip' for status
  Widget _buildStatusFilterItem(TaskStatus? status, String label) {
    final isSelected = (_selectedStatusFilter == status);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatusFilter = status;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
              ),
        ),
      ),
    );
  }

  /// Single filter 'chip' for priority
  Widget _buildPriorityFilterItem(TaskPriority? priority, String label) {
    final isSelected = (_selectedPriorityFilter == priority);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPriorityFilter = priority;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 12,
              ),
        ),
      ),
    );
  }
}

// class _TasksPageState extends State<TasksPage> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<TasksCubit, TasksState>(
//       builder: (context, state) {
//         // Show a loading spinner while data is being fetched.
//         if (state.fetchStatus.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         // Display an error message if needed.
//         if (state.fetchStatus.failed) {
//           return Center(
//               child: Text('Error: ${state.fetchStatus.failureMessage}'));
//         }

//         // Show a message if there are no tasks.
//         if (state.tasks.isEmpty) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Center(
//                   child: SvgPicture.asset(
//                     'assets/icons/empty-task..svg',
//                     width: 120,
//                     colorFilter: ColorFilter.mode(
//                       Colors.blue,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ),
//                 Text(
//                   'You do Not have any Tasks',
//                   style: Theme.of(context).textTheme.bodyMedium!.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 15,
//                   ),
//                   child: Text(
//                     'You have no tasks yet, kindly add tasks ',
//                     textAlign: TextAlign.center,
//                     style: Theme.of(context).textTheme.bodySmall,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }

//         // Display the list of tasks.
//         final tasks = List<TaskModel>.from(state.tasks);

//         return Column(
//           children: [
//             // GestureDetector(
//             //   onTap: () => Navigator.push(context,
//             //       MaterialPageRoute(builder: (context) => AllTasksPage())),
//             //   child: Text('View More'),
//             // ),
//             Padding(
//               padding: const EdgeInsets.all(15),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Center(
//                         child: Column(
//                           children: [
//                             Text(
//                               '257',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyLarge!
//                                   .copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 24,
//                                     color: Colors.black,
//                                   ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               'Completed Task',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyMedium!
//                                   .copyWith(
//                                     color: Colors.black,
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     width: 30,
//                   ),
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.all(15),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Center(
//                         child: Column(
//                           children: [
//                             Text(
//                               '257',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyLarge!
//                                   .copyWith(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 24,
//                                     color: Colors.black,
//                                   ),
//                             ),
//                             const SizedBox(
//                               height: 10,
//                             ),
//                             Text(
//                               'Completed Task',
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .bodyMedium!
//                                   .copyWith(
//                                     color: Colors.black,
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Tasks',
//                   textAlign: TextAlign.center,
//                   style: Theme.of(context).textTheme.bodySmall,
//                 ),
//                 GestureDetector(
//                   onTap: () => Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => AllTasksPage())),
//                   child: Text('See More'),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(15),
//                 itemCount: tasks.length,
//                 itemBuilder: (context, index) {
//                   final task = tasks[index];
//                   return GestureDetector(
//                     onTap: () {
//                       context
//                           .read<TasksCubit>()
//                           .fetchTaskById(taskId: task.uniqueId);
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => TaskDetail(),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(bottom: 10),
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: GlobalFunctions().getStatusColor(task.status),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             GlobalFunctions()
//                                 .getTaskCategoryDisplay(task.category),
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium!
//                                 .copyWith(
//                                   color: Colors.black,
//                                 ),
//                           ),
//                           Text(
//                             task.title,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyMedium!
//                                 .copyWith(
//                                   color: Colors.black,
//                                 ),
//                           ),
//                           const SizedBox(
//                             height: 10,
//                           ),
//                           Text(
//                             task.description,
//                             style:
//                                 Theme.of(context).textTheme.bodySmall!.copyWith(
//                                       color: Colors.black,
//                                     ),
//                           ),
//                           const SizedBox(
//                             height: 15,
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Text(
//                                 GlobalFunctions().formatDate(task.startDate!),
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .bodyMedium!
//                                     .copyWith(
//                                       color: Colors.black,
//                                     ),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                   // return ListTile(
//                   //   title: Text(task.title),
//                   //   subtitle: Text(task.description),
//                   //   trailing: Text(task.status.name),
//                   // );
//                 },
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
