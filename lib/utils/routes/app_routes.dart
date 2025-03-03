
import 'package:task_manager/features/auth/ui/sign_in.dart';
import 'package:task_manager/features/auth/ui/sign_up.dart';
import 'package:task_manager/features/home/ui/landing.dart';
import 'package:task_manager/utils/routes/routes.dart';

class AppRoutes {
  static final routes = {
    Routes.signIn: (context) => SignIn(),
    Routes.signUp: (context) => SignUp(),
    Routes.landing: (context) => const Landing(),
    // Routes.workers: (context) => const WorkersPage(),
    // Routes.notifications: (context) => const Notifications(),
  };
}
