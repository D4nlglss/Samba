import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:samba/components/my_category.dart';
import 'package:samba/components/text_field.dart';

class ManageCategories extends StatefulWidget {
  const ManageCategories({super.key});

  @override
  State<ManageCategories> createState() => _ManageCategoriesState();
}

// Pantalla de administración de categorías
class _ManageCategoriesState extends State<ManageCategories> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Crear categoría
  void addCategory(String title, String color) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('categories')
        .doc(title)
        .set({
      'title': title,
      'color': color,
    });
  }

  // Diálogo para crear una categoría
  void addCategoryDialog(BuildContext context) {
    var controller = TextEditingController();
    Color color = Theme.of(context).canvasColor;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: const Center(child: Text('Crear categoría')),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ColorPicker(
                      pickerColor: color,
                      enableAlpha: false,
                      // ignore: deprecated_member_use
                      showLabel: false,
                      onColorChanged: (value) => setState(() {
                            color = value;
                          })),
                  const SizedBox(
                    height: 5,
                  ),
                  MyTextFieldII(
                      controller: controller,
                      action: TextInputAction.done,
                      hintText: 'Categoría',
                      obscureText: false),
                  const SizedBox(
                    height: 20,
                  ),
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
                          addCategory(controller.text, color.toString());
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.add_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  // Confirmar borrado de categoría
  void confirmDeleteCategory(BuildContext context, String title, Color color) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: const Center(
              child: Text('Borrar Categoría'),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '¿Eliminar ésta categoría?',
                ),
                Container(
                  decoration: BoxDecoration(
                      color: color, borderRadius: BorderRadius.circular(8)),
                  margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
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
                      Navigator.pop(context);
                      deleteCategory(title);
                    },
                    child: const Icon(Icons.check),
                  ),
                ),
              ),
            ],
          );
        });
  }

  // Preparar color de la categoría
  Color getColor(String color) {
    Color usableColor = Theme.of(context).canvasColor;
    if (!color.contains('Theme')) {
      String? convertedColor = color.split('(0x')[1].split(')')[0];
      int value = int.parse(convertedColor, radix: 16);
      usableColor = Color(value);
    }
    return usableColor;
  }

  // Borrar categoría
  void deleteCategory(String title) async {
    // Notas del usuario
    final userNotes = await FirebaseFirestore.instance
        .collection('notes')
        .where('owner', isEqualTo: currentUser.email)
        .get();

    for (var note in userNotes.docs) {
      // Categorías de la nota
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(note.id)
          .collection('categories')
          .doc(title)
          .delete();
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('categories')
        .doc(title)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Tus Categorías'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Expanded(
                    child:
                        // Se obtienen todas las categorías
                        StreamBuilder<QuerySnapshot>(
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
                              if (snapshot.data!.docs.isEmpty) {
                                return Center(
                                  child: Text(
                                    'Para crear una categoría\npresiona el botón "+"',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        fontSize: 20),
                                  ),
                                );
                              }
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.035,
                                child: ListView(
                                  children: snapshot.data!.docs.map((doc) {
                                    final categoryData =
                                        doc.data() as Map<String, dynamic>;
                                    return MyCategory(
                                      title: categoryData['title'],
                                      color: categoryData['color'],
                                      onTap: () {
                                        confirmDeleteCategory(
                                            context,
                                            categoryData['title'],
                                            getColor(categoryData['color']));
                                      },
                                      inNote: false,
                                    );
                                  }).toList(),
                                ),
                              );
                            }),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MaterialButton(
                  shape: const CircleBorder(),
                  onPressed: () {
                    addCategoryDialog(context);
                  },
                  color: Theme.of(context).colorScheme.background,
                  padding: const EdgeInsets.all(13),
                  child: const Text('+', style: TextStyle(fontSize: 32)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
