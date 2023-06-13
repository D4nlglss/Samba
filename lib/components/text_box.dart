import 'package:flutter/material.dart';

// Cuadros de texto en la pantalla de perfil
class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;

  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(left: 15, bottom: 25),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
              IconButton(
                onPressed: onPressed,
                icon: Icon(Icons.settings,
                    color: Theme.of(context).colorScheme.tertiary),
              )
            ],
          ),
          Text(text),
        ],
      ),
    );
  }
}
