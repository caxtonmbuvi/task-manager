import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager/features/calendar/ui/calendar.dart';
import 'package:task_manager/features/profile/cubit/profile_cubit.dart';
import 'package:task_manager/features/profile/cubit/profile_state.dart';
import 'package:task_manager/features/profile/ui/profile.dart';
import 'package:task_manager/features/task/cubit/tasks_cubit.dart';
import 'package:task_manager/features/task/ui/add_task.dart';
import 'package:task_manager/features/task/ui/tasks_page.dart';
import 'package:task_manager/utils/global_functions/global_functions.dart';

import 'package:task_manager/utils/widgets/themed_page.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    context.read<ProfileCubit>().getUserProfile();
    context.read<TasksCubit>().fetchTasks(isRefresh: true);
  }

  List<Widget> widgetOptions = <Widget>[
    TasksPage(),
    CalendarPage(),
    Container(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showFullPagePopup(BuildContext context) {
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
          task: null,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greeting = GlobalFunctions().getGreeting(
      DateTime.now(),
    );
    return ThemedPage(
      appBar: _selectedIndex == 0
          ? AppBar(
              centerTitle: false,
              leading: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state.profileStatus.succeeded) {
                    return Container(
                      padding: EdgeInsets.only(
                        left: 15,
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          GlobalFunctions().getAvatarText(state.profile!.name),
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    greeting,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      return Text(
                        state.profile?.name ?? '',
                        style: Theme.of(context).textTheme.bodyLarge,
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
      body: widgetOptions[_selectedIndex],
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () => showFullPagePopup(context),
              // onPressed: () => _addRandomTask(),
              // Create a rounded button using a custom shape.
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            )
          : null,
      // Position the FAB at the bottom right.
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(
                color: theme.dividerColor,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildNavItem('assets/icons/home.svg', 'Home', 0),
              buildNavItem('assets/icons/calendar.svg', 'Calendar', 1),
              buildNavItem('assets/icons/chart.svg', 'Activities', 2),
              buildNavItem('assets/icons/profile.svg', 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNavItem(String assetPath, String label, int index) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              assetPath,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.blue : Colors.grey,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
