import 'package:flutter/material.dart';

class Friends extends StatelessWidget {
  final String email;
  final bool inNote;
  final Function()? onTap;

  const Friends(
      {super.key, required this.email, required this.inNote, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (inNote) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          child: Center(
            child: Text(email, style: const TextStyle(color: Colors.white)),
          ),
        ),
      );
    } else {
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
}
