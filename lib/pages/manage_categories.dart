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

class _ManageCategoriesState extends State<ManageCategories> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  void addCategory(String title, String color) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('categories')
        .add({
      'title': title,
      'color': color,
    });
  }

  void addCategoryDialog(BuildContext context) {
    var controller = TextEditingController();
    Color color = Theme.of(context).canvasColor;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
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
                          borderRadius: BorderRadius.circular(7),
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
