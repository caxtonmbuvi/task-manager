import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/features/task/repo/tasks_repo.dart';

import 'package:task_manager/utils/routes/routes.dart';
import 'package:task_manager/utils/services/firebase_service.dart';
import 'package:task_manager/utils/services/sync_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay execution until after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSignInStatus();
    });
  }

  Future<void> _checkSignInStatus() async {
    // Only attempt sync if a user is signed in.
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await SyncService(
          tasksRepo: context.read<TasksRepo>(),
          firebaseService: context.read<FirebaseService>(),
        ).syncTasks();
      if (mounted) Navigator.pushReplacementNamed(context, Routes.landing);
    } else {
      Navigator.pushReplacementNamed(context, Routes.signIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
