import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(color: Color(0xFFF4E3CF)),
  iconTheme: IconThemeData(
    color: Colors.grey[900],
  ),
  canvasColor: const Color(0xFFF4E3CF),
  textTheme: const TextTheme(
    displaySmall: TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    displayMedium: TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  colorScheme: ColorScheme.dark(
      background: Colors.orange.shade600,
      primary: Colors.amber[400]!,
      secondary: Colors.amber[300]!,
      tertiary: Colors.black26,
      // tertiary: ,
      brightness: Brightness.light),
  scaffoldBackgroundColor: const Color(0xFFFDEEDC),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(color: Colors.black26),
    labelStyle: const TextStyle(color: Colors.black),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.amber[400]!,
      ),
    ),
  ),
  primarySwatch: Colors.orange,
);
