import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/cubit/auth_cubit.dart';
import 'package:task_manager/features/auth/repo/auth_repo.dart';
import 'package:task_manager/features/calendar/cubit/calendar_cubit.dart';
import 'package:task_manager/features/profile/cubit/profile_cubit.dart';
import 'package:task_manager/features/profile/repo/profile_repo.dart';
import 'package:task_manager/features/task/cubit/tasks_cubit.dart';
import 'package:task_manager/features/task/repo/tasks_repo.dart';
import 'package:task_manager/utils/cubits/terms_cubit.dart';
import 'package:task_manager/utils/cubits/theme/theme_cubit.dart';

class GlobalCubitProvider extends StatelessWidget {
  const GlobalCubitProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeCubit(),
        ),
        BlocProvider(
          create: (context) => TermsCubit(),
        ),
        BlocProvider(
          create: (context) => TasksCubit(repo: TasksRepo()),
        ),
        BlocProvider(
          create: (context) => CalendarCubit(repo: TasksRepo()),
        ),
        BlocProvider(
          create: (context) => AuthCubit(AuthRepo()),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(ProfileRepo()),
        ),
      ],
      child: child,
    );
  }
}
