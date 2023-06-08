import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction action;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.action,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primary,
      textInputAction: action,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 17,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class MyTextFieldII extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction action;
  final String hintText;
  final bool obscureText;

  const MyTextFieldII({
    super.key,
    required this.controller,
    required this.action,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Theme.of(context).colorScheme.primary,
      textInputAction: action,
      obscureText: obscureText,
      style: const TextStyle(
        fontSize: 17,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).canvasColor,
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

