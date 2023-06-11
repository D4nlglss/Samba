import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(color: Color(0xFF352F44)),
  iconTheme: const IconThemeData(
    color: Colors.white
  ),
  canvasColor: const Color(0xFF352F44),
  textTheme: const TextTheme(
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold
    ),
  ),
  colorScheme: ColorScheme.dark(
      background: const Color(0xFF591F61),
      primary: Colors.pink[800]!,
      secondary: Colors.pink.shade300,
      tertiary: Colors.white30,
      brightness: Brightness.dark),
  scaffoldBackgroundColor: const Color(0xFF2A2438),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(color: Colors.white30),
    labelStyle: const TextStyle(color: Colors.white),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.pink[800]!,
      ),
    ),
  ),
  primarySwatch: Colors.deepPurple,
);
