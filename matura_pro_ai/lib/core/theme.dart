import 'package:flutter/material.dart';
import 'theme_defaults.dart';
class AppTheme {
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: ThemeDefaults.primaryColor,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
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
    
  );

  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: ThemeDefaults.primaryColor,
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
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

    elevatedButtonTheme: ThemeDefaults.elevatedButtonTheme,
  );
}