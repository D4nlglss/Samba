import 'package:flutter/material.dart';

void displayMessage(String message, BuildContext context, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: color,
    duration: const Duration(seconds: 3),
    content: Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    ),
  ));
}
