import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samba/components/my_category.dart';
import 'package:samba/components/text_field.dart';

class NoteWall extends StatefulWidget {
  final String title;
  final String noteId;
  final String? owner;
  final String? body;
  final String? color;
  final String? textColor;

  const NoteWall({
    super.key,
    required this.title,
    required this.noteId,
    required this.body,
    this.owner,
    this.color,
    this.textColor,
  });

  @override
  State<NoteWall> createState() => _NoteWallState();
}

class _NoteWallState extends State<NoteWall> {
  final _categoryController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Preparar color de fondo para la ui
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
  TextStyle getTextColor(BuildContext context) {
    TextStyle text = Theme.of(context).textTheme.displayMedium!;
    if (widget.textColor!.contains('Color')) {
      String? colorFromData = widget.textColor!.split('(0x')[1].split(')')[0];
      int value = int.parse(colorFromData, radix: 16);
      Color usableColor = Color(value);
      text = TextStyle(color: usableColor);
    }
    return text;
  }

  void addCategory(String title, String color) {
    FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.noteId)
        .collection('categories')
        .doc(title)
        .set({
      'title': title,
      'color': color,
    });
  }

  void showCategoryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Center(child: Text('Añadir categoría')),
            content: SizedBox(
              width: 50,
              height: 350,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.email)
                      .collection('categories')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.035,
                      child: ListView(
                        children: snapshot.data!.docs.map((doc) {
                          final categoryData =
                              doc.data() as Map<String, dynamic>;
                          return MyCategory(
                            title: categoryData['title'],
                            color: categoryData['color'],
                            inNote: false,
                            onTap: () {
                              addCategory(
                                  categoryData['title'], categoryData['color']);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }),
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
                    onPressed: () => Navigator.pop(context),
                    child: const Icon(Icons.check),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: getNoteColor(context),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        children: [
          Text(widget.title, style: getTextColor(context)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Categorías:', style: TextStyle(fontSize: 16)),
              IconButton(
                onPressed: showCategoryDialog,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notes')
                  .doc(widget.noteId)
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.035,
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    children: snapshot.data!.docs.map((doc) {
                      final categoryData = doc.data() as Map<String, dynamic>;

                      return MyCategory(
                        title: categoryData['title'],
                        color: categoryData['color'],
                        inNote: true,
                      );
                    }).toList(),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
