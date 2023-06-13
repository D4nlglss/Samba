import 'package:flutter/material.dart';

// Botón personalizado
class MyButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;

  const MyButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: 150,
        margin: const EdgeInsets.symmetric(horizontal: 60),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.background,
        ),
        child: TextButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            overlayColor: MaterialStateColor.resolveWith(
                (states) => Theme.of(context).colorScheme.primary),
          ),
          onPressed: onPressed,
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
