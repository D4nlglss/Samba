import 'package:flutter/material.dart';

// Widget de categorías
class MyCategory extends StatelessWidget {
  final String title;
  final String color;
  final bool inNote;
  final Function()? onTap;

  const MyCategory(
      {super.key,
      required this.title,
      required this.color,
      required this.inNote,
      this.onTap});

  // Preparar color de fondo para la ui
  Color getCategoryColor(BuildContext context) {
    Color usableColor = Theme.of(context).canvasColor;
    if (!color.contains('Theme')) {
      String? convertedColor = color.split('(0x')[1].split(')')[0];
      int value = int.parse(convertedColor, radix: 16);
      usableColor = Color(value);
    }
    return usableColor;
  }

  @override
  Widget build(BuildContext context) {
    if (inNote) {
      return Padding(
        padding: const EdgeInsets.only(left: 2, right: 2),
        child: Container(
          decoration: BoxDecoration(
            color: getCategoryColor(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            child: Center(
              child: Text(title, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: getCategoryColor(context),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(4,4),
                spreadRadius: 1,
                blurRadius: 0,
              )
            ],
          ),
          margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
          padding: const EdgeInsets.only(top: 25, bottom: 25),
          child: Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white)),
        ),
      );
    }
  }
}
