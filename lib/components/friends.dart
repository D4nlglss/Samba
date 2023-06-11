import 'package:flutter/material.dart';

class Friends extends StatelessWidget {
  final String email;
  final Function()? onTap;

  const Friends(
      {super.key, required this.email, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
        padding: const EdgeInsets.only(top: 25, bottom: 25),
        child: Text(email,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
