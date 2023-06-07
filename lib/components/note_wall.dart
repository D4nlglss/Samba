import 'package:flutter/material.dart';

class NoteWall extends StatelessWidget {
  final String title;
  final String? owner;
  final String? body;
  final String? color;
  final String? textColor;
  // ignore: prefer_typing_uninitialized_variables
  final category;

  const NoteWall({
    super.key,
    required this.title,
    required this.body,
    this.owner,
    this.category,
    this.color,
    this.textColor,
  });

// Preparar color de fondo para la ui
  Color getNoteColor(BuildContext context) {
    Color usableColor = Theme.of(context).canvasColor;
    if (!color!.contains('Theme')) {
      String? convertedColor = color!.split('(0x')[1].split(')')[0];
      int value = int.parse(convertedColor, radix: 16);
      usableColor = Color(value);
    }
    return usableColor;
  }

  // Preparar color del texto para la ui
  TextStyle getTextColor(BuildContext context) {
    TextStyle text = Theme.of(context).textTheme.displaySmall!;
    if (textColor!.contains('Color')) {
      String? colorFromData = textColor!.split('(0x')[1].split(')')[0];
      int value = int.parse(colorFromData, radix: 16);
      Color usableColor = Color(value);
      text = TextStyle(color: usableColor);
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: getNoteColor(context),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Column(
            children: [
              Text(title, style: getTextColor(context)),
            ],
          ),
        ],
      ),
    );
  }
}
