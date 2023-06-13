import 'package:flutter/material.dart';
import 'package:samba/components/text_field.dart';

// Diálogo personalizado
void myDialog(BuildContext context, String message,
    TextEditingController textController, Function() onPressed, Icon icon) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).canvasColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () {
                    onPressed();
                  },
                  child: icon,
                ),
              ),
            ),
          ],
        );
      });
}
