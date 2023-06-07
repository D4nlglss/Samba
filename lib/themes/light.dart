import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(color: Color(0xFFF4E3CF)),
  canvasColor: const Color(0xFFF4E3CF),
  textTheme: const TextTheme(
    displaySmall: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
  ),
  colorScheme: ColorScheme.dark(
      background: Colors.orange.shade600,
      primary: Colors.amber.shade400,
      secondary: Colors.yellow.shade300,
      tertiary: Colors.orange,
      brightness: Brightness.light),
  scaffoldBackgroundColor: const Color(0xFFFDEEDC),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.black26),
    labelStyle: TextStyle(color: Colors.black),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.orange,
      ),
    ),
  ),
  primarySwatch: Colors.orange,
);
