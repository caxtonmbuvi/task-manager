import 'package:flutter/material.dart';
import 'package:task_manager/utils/global_providers/global_cubit_provider.dart';
import 'package:task_manager/utils/global_providers/global_repository_provider.dart';
class GlobalProviders extends StatelessWidget {
  const GlobalProviders({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlobalRepositoryProvider(
      child: GlobalCubitProvider(
        child: child,
      ),
    );
  }


}
