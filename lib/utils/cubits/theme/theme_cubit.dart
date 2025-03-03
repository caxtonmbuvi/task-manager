import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/utils/cubits/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(_lightTheme));

  // Light Theme.
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    // Override the primary color.
    colorScheme: ColorScheme.fromSwatch().copyWith(),
    scaffoldBackgroundColor: Colors.white,

    // ElevatedButton theming (applies to all ElevatedButtons by default).
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Text color on the button.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
    ),

    dividerColor: Colors.black,

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 16),
      bodySmall: TextStyle(color: Colors.black, fontSize: 12),
      // Add all text styles you need.
    ),

    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.white38,
    ),
  );

  // Dark Theme.
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blueGrey,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 16),
      bodySmall: TextStyle(color: Colors.white, fontSize: 12),
      // Add all text styles you need.
    ),
    dividerColor: Colors.white,
    bottomAppBarTheme: const BottomAppBarTheme(
      color: Colors.black38,
    ),
  );

  /// Toggles between Light & Dark.
  void toggleTheme() {
    final isLight = state.themeData.brightness == Brightness.light;
    emit(ThemeState(isLight ? _darkTheme : _lightTheme));
  }
}
