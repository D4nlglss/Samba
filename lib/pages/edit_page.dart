import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

// Clase para editar las notas
// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  final String title;
  final String noteId;
  final String? owner;
  final String body;
  String? color;
  String? textColor;
  EditPage({
    super.key,
    required this.title,
    required this.noteId,
    required this.body,
    this.owner,
    this.color,
    this.textColor,
  });

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final titleController = TextEditingController();
  final bodyController = TextEditingController();

  // Preparar color de la nota para la ui
  Color getNoteColor(BuildContext context) {
    Color usableColor = Theme.of(context).canvasColor;
    if (!widget.color!.contains('Theme')) {
      String? convertedColor = widget.color!.split('(0x')[1].split(')')[0];
      int value = int.parse(convertedColor, radix: 16);
      usableColor = Color(value);
    }
    return usableColor;
  }

  // Preparar color del texto para la ui
  Color getTextColor(BuildContext context) {
    Color usableColor = Theme.of(context).textTheme.displayMedium!.color!;
    if (widget.textColor!.contains('Color')) {
      String? colorFromData = widget.textColor!.split('(0x')[1].split(')')[0];
      int value = int.parse(colorFromData, radix: 16);
      usableColor = Color(value);
    }
    return usableColor;
  }

  @override
  void initState() {
    super.initState();
    titleController.text = widget.title;
    bodyController.text = widget.body;
  }

  // Guardar nota
  void saveNote() async {
    await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.noteId)
        .set({
      'title': titleController.text,
      'owner': currentUser.email,
      'body': bodyController.text,
      'color': widget.color,
      'textColor': widget.textColor
    });
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  // Selector de color
  void pickColor(String element) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).canvasColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              title: const Text('Elige un color'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ColorPicker(
                      pickerColor: getNoteColor(context),
                      enableAlpha: false,
                      // ignore: deprecated_member_use
                      showLabel: false,
                      onColorChanged: (color) => setState(() {
                            if (element == 'note') {
                              widget.color = color.toString();
                            } else if (element == 'text') {
                              widget.textColor = color.toString();
                            }
                          })),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Seleccionar',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Edición'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: getNoteColor(context),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(5, 5),
                      spreadRadius: 1,
                      blurRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      style: TextStyle(
                          color: getTextColor(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 26),
                      textAlign: TextAlign.center,
                      controller: titleController,
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextField(
                              autofocus: true,
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                              style: TextStyle(color: getTextColor(context)),
                              maxLines: null,
                              textAlign: TextAlign.start,
                              controller: bodyController,
                              textInputAction: TextInputAction.newline,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SpeedDial(
                    buttonSize: const Size(55, 55),
                    switchLabelPosition: true,
                    icon: Icons.palette,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    useRotationAnimation: true,
                    iconTheme: const IconThemeData(
                      color: Colors.white,
                      size: 35,
                    ),
                    elevation: 1.7,
                    overlayColor: Colors.black,
                    overlayOpacity: 0.4,
                    spacing: 30,
                    spaceBetweenChildren: 6,
                    children: [
                      SpeedDialChild(
                          child: const Icon(Icons.format_color_fill),
                          label: 'Color de la nota',
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          onTap: () {
                            pickColor('note');
                          }),
                      SpeedDialChild(
                          child: const Icon(Icons.format_color_text),
                          label: 'Color de texto',
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          onTap: () {
                            pickColor('text');
                          }),
                    ],
                  ),
                  MaterialButton(
                    color: Theme.of(context).colorScheme.secondary,
                    shape: const CircleBorder(),
                    onPressed: saveNote,
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
