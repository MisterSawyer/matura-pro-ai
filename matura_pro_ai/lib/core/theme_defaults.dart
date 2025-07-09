import 'package:flutter/material.dart';

class ThemeDefaults {
  static const double padding = 16.0;

  static const MaterialColor primaryColor = Colors.blue;
  static const MaterialAccentColor errorColor = Colors.redAccent;
  static final ElevatedButtonThemeData elevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: const StadiumBorder(
      ),
      backgroundColor: Colors.white,
      foregroundColor: const Color(0XFF0A2645),
      textStyle: const TextStyle(
        color: Color(0XFF0A2645),
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
static const TextTheme textTheme = TextTheme(
  titleLarge: TextStyle(
    fontFamily : 'Gagalin',
    fontSize: 48,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  ),
  headlineLarge: TextStyle(
    fontFamily : 'Gagalin',
    fontSize: 72,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.0,
  ),
);
}
