import 'package:flutter/material.dart';

// Tema oscuro
ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(color: Color(0xFF352F44)),
  iconTheme: const IconThemeData(color: Colors.white),
  canvasColor: const Color(0xFF352F44),
  textTheme: const TextTheme(
    displaySmall: TextStyle(
      color: Colors.white,
      fontSize: 14,
    ),
    displayMedium: TextStyle(
        color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  colorScheme: const ColorScheme.dark(
      background: Color(0xFF66347F),
      primary: Color(0xFF654E92),
      secondary: Color(0xFF6C9BCF),
      tertiary: Colors.white30,
      brightness: Brightness.dark),
  scaffoldBackgroundColor: const Color(0xFF2A2438),
  inputDecorationTheme: const InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.white30),
    labelStyle: TextStyle(color: Colors.white),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color(0xFF654E92),
      ),
    ),
  ),
  primarySwatch: Colors.purple,
);
