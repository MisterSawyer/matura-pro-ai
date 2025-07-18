import 'package:flutter/material.dart';
import 'theme_defaults.dart';
class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: ThemeDefaults.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      foregroundColor: Color(0XFF0A2645),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: ThemeDefaults.primaryColor,
        error: ThemeDefaults.errorColor, // ← error color here
    ),

    elevatedButtonTheme: ThemeDefaults.elevatedButtonTheme,
    textTheme : ThemeDefaults.textTheme,
  );

  static final ThemeData dark = ThemeData(
    primaryColor: ThemeDefaults.primaryColor,
    brightness: Brightness.dark,
    primarySwatch: ThemeDefaults.primaryColor,
    scaffoldBackgroundColor: const Color(0XFF0A2645),
    appBarTheme: const AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Color(0XFF0A2645),
      foregroundColor: Colors.white,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF1F1F1F),
    ),
    colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: ThemeDefaults.primaryColor,
        error: ThemeDefaults.errorColor, // ← error color here
    ),
    //bodyMedium: const TextStyle(color: Colors.white),
    elevatedButtonTheme: ThemeDefaults.elevatedButtonTheme,
    textTheme : ThemeDefaults.textTheme,
  );
}