import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/auth/repo/auth_repo.dart';
import 'package:task_manager/features/profile/repo/profile_repo.dart';
import 'package:task_manager/features/task/repo/tasks_repo.dart';
import 'package:task_manager/utils/services/connectivity_service.dart';
import 'package:task_manager/utils/services/firebase_service.dart';
import 'package:task_manager/utils/services/sync_service.dart';

class GlobalRepositoryProvider extends StatelessWidget {
  const GlobalRepositoryProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepo(),
        ),
        RepositoryProvider(
          create: (context) => TasksRepo(),
        ),
        RepositoryProvider(
          create: (context) => FirebaseService(),
        ),
        RepositoryProvider(
          create: (context) => SyncService(
            tasksRepo: context.read<TasksRepo>(),
            firebaseService: context.read<FirebaseService>(),
          ),
        ),
        RepositoryProvider(create: (_) => ConnectivityService()),

        RepositoryProvider(
          create: (context) => ProfileRepo(),
        ),
      ],
      child: child,
    );
  }
}
