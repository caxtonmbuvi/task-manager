
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/utils/cubits/theme/theme_cubit.dart';
import 'package:task_manager/utils/cubits/theme/theme_state.dart';
import 'package:task_manager/utils/global_providers/global_providers.dart';
import 'package:task_manager/utils/routes/app_routes.dart';
import 'package:task_manager/utils/widgets/navigator_service.dart';


final routeObserver = RouteObserver<PageRoute<dynamic>>();

class App extends StatelessWidget {
  const App({super.key, required this.widget});

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return GlobalProviders(
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            navigatorKey: NavigatorService.navigatorKey,
            debugShowCheckedModeBanner: false,
            home: widget,
            navigatorObservers: [routeObserver],
            theme: themeState.themeData, 
            routes: AppRoutes.routes,
          );
        },
      ),
    );
  }
}
