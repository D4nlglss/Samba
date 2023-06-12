import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samba/components/my_category.dart';
import 'package:samba/components/snackbar.dart';
import 'package:samba/components/speed_dial.dart';

import 'friend.dart';

class NoteWall extends StatefulWidget {
  final String title;
  final String noteId;
  final String? owner;
  final String body;
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
  Color getTextColor(BuildContext context) {
    Color usableColor = Theme.of(context).textTheme.displayMedium!.color!;
    if (widget.textColor!.contains('Color')) {
      String? colorFromData = widget.textColor!.split('(0x')[1].split(')')[0];
      int value = int.parse(colorFromData, radix: 16);
      usableColor = Color(value);
    }
    return usableColor;
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

  void removeCategory(String title) {
    FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.noteId)
        .collection('categories')
        .doc(title)
        .delete();
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
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }),
            ),
          );
        });
  }

  void showRemoveCategoryDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Center(child: Text('Quitar categoría')),
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
                              removeCategory(categoryData['title']);
                              Navigator.pop(context);
                            },
                          );
                        }).toList(),
                      ),
                    );
                  }),
            ),
          );
        });
  }

  void confirmDeleteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Center(
              child: Text('Borrar nota'),
            ),
            content: const Text('Esta acción no se puede deshacer'),
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
                      deleteNote();
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.check),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void goToEditPage() {}

  void deleteNote() async {
    final categoriesDoc = await FirebaseFirestore.instance
        .collection('notes')
        .doc(widget.noteId)
        .collection('categories')
        .get();

    for (var doc in categoriesDoc.docs) {
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(widget.noteId)
          .collection('categories')
          .doc(doc.id)
          .delete();
    }
    FirebaseFirestore.instance.collection('notes').doc(widget.noteId).delete();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  }

  void shareNoteDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Center(child: Text('Compartir con ...')),
            content: SizedBox(
              width: 50,
              height: 350,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.email)
                      .collection('friends')
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
                          final friendData = doc.data() as Map<String, dynamic>;
                          return Friend(
                              email: friendData['email'],
                              onTap: () {
                                shareNote(friendData['email']);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                        }).toList(),
                      ),
                    );
                  }),
            ),
          );
        });
  }

  void shareNote(String email) {
    FirebaseFirestore.instance.collection('notes').add({
      'title': widget.title,
      'owner': email,
      'body': widget.body,
      'color': 'Theme.of(context).canvasColor',
      'textColor': ' '
    });
    displayMessage('Se ha compartido la nota', context, Colors.green.shade400);
  }

  void enlargeNote() {
    showDialog(
        context: context,
        builder: (context) {
          return Padding(
            padding:
                const EdgeInsets.only(top: 80, bottom: 80, left: 30, right: 30),
            child: Container(
              decoration: BoxDecoration(
                  color: getNoteColor(context),
                  borderRadius: BorderRadius.circular(10)),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MySpeedDial(
                            edit: goToEditPage,
                            delete: confirmDeleteDialog,
                            share: shareNoteDialog),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, bottom: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Center(
                          child: Text(
                            widget.title,
                            style: TextStyle(
                                color: getTextColor(context),
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  widget.body,
                                  style: TextStyle(
                                      color: getTextColor(context),
                                      fontSize: 16),
                                ),
                              ],
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enlargeNote,
      child: Container(
        decoration: BoxDecoration(
            color: getNoteColor(context),
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  color: getTextColor(context),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                const Text('Categorías:', style: TextStyle(fontSize: 16)),
                const Expanded(child: SizedBox()),
                IconButton(
                  color: Theme.of(context).colorScheme.tertiary,
                  onPressed: showRemoveCategoryDialog,
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  color: Theme.of(context).colorScheme.tertiary,
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
      ),
    );
  }
}
