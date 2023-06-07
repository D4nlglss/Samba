import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(color: Color(0xFF3C4480)),
  canvasColor: const Color(0xFF3C4480),
  colorScheme: ColorScheme.dark(
      background: const Color(0xFF8B2F97),
      primary: const Color(0xFFCF56A1),
      secondary: Colors.pink.shade300,
      tertiary: Colors.purple,
      brightness: Brightness.dark),
  scaffoldBackgroundColor: const Color(0xFF37306B),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.white70),
    labelStyle: TextStyle(color: Colors.white),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.purple,
      ),
    ),
  ),
  primarySwatch: Colors.purple,
);
