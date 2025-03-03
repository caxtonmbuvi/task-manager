import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:task_manager/features/auth/repo/auth_repo.dart';
import 'package:task_manager/features/profile/cubit/profile_cubit.dart';
import 'package:task_manager/features/profile/cubit/profile_state.dart';
import 'package:task_manager/features/profile/repo/profile_repo.dart';
import 'package:task_manager/features/profile/ui/widgets/mode_switcher.dart';
import 'package:task_manager/features/profile/ui/widgets/profile_item.dart';
import 'package:task_manager/utils/cubits/theme/theme_cubit.dart';
import 'package:task_manager/utils/global_functions/global_functions.dart';
import 'package:task_manager/utils/routes/routes.dart';
import 'package:path/path.dart' as p;

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // Use watch so that the widget rebuilds when theme state changes.
    final themeCubit = context.watch<ThemeCubit>();
    final isDarkMode = themeCubit.state.themeData.brightness == Brightness.dark;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.profileStatus.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.profileStatus.failed) {
          return Text(state.profileStatus.failureMessage!);
        } else if (state.profileStatus.succeeded) {
          final profile = state.profile;
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            GlobalFunctions().getAvatarText(profile!.name),
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 50,
                                    ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        profile.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                      ),
                      Text(profile.email),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      ModeSwitcher(
                        title: isDarkMode ? 'Dark Mode' : 'Light Mode',
                        iconData:
                            isDarkMode ? Icons.dark_mode : Icons.light_mode,
                        isDarkMode: isDarkMode,
                        onToggle: (_) => themeCubit.toggleTheme(),
                        primaryColor: isDarkMode ? Colors.white : Colors.black,
                        secondaryColor: isDarkMode
                            ? Colors.grey.shade800
                            : Colors.blue.shade100,
                      ),
                      const SizedBox(height: 15),
                      ProfileItem(
                        ontap: () => _confirmLogout(context),
                        iconData: Icons.logout,
                        primaryColor: Colors.red,
                        secondaryColor: Colors.red.shade100,
                        title: 'Log Out',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () => logout(context),
            ),
          ],
        );
      },
    );
  }

  void logout(BuildContext context) async {
    context.read<AuthRepo>().signout();
    context.read<ProfileRepo>().clearDatabase();
    Navigator.of(context).pop();
    Navigator.pushReplacementNamed(context, Routes.signIn);
  }
}
