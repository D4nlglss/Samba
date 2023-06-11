import 'package:flutter/material.dart';
import 'package:samba/components/text_field.dart';

void addNoteDialog(BuildContext context, String message,
    TextEditingController textController, Function() onPressed) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).canvasColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          title: Center(child: Text(message)),
          content: MyTextFieldII(
            controller: textController,
            hintText: 'Título',
            obscureText: false,
            action: TextInputAction.done,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Center(
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.55,
                  height: MediaQuery.of(context).size.width * 0.13,
                  color: Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  onPressed: () {
                    onPressed();
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.add_outlined),
                ),
              ),
            ),
          ],
        );
      });
}

