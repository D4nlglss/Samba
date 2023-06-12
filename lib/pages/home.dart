import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:samba/components/drawer.dart';
import 'package:samba/components/note_wall.dart';
import 'package:samba/components/alert_dialog.dart';
import 'package:samba/pages/filter_by_category.dart';
import 'package:samba/pages/manage_categories.dart';
import 'package:samba/pages/manage_friends.dart';
import 'package:samba/pages/profile_page.dart';
import 'package:samba/pages/search_by_title_page.dart';

import '../components/my_category.dart';

//TODO
//! Importar/Exportar: añadir opciñon al speed dial para crear archivo con el cuerpo de la nota
//! y el título como nombre del archivo.txt. Añadir menú en la appbar para importar un archivo.txt.
//* Notas: Buscar (speed dial con botón que invoca un dialog para buscar titulo y otro para filtrar por categoría)

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();
  // Cerrar sesión
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // Añadir notas
  void addNote() {
    Navigator.pop(context);
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('notes').add({
        'title': textController.text,
        'owner': currentUser.email,
        'body': '',
        'color': 'Theme.of(context).canvasColor',
        'textColor': ' '
      });
    }
    textController.text = '';
  }

  uploadNote() {
    myDialog(context, 'Añadir nota', textController, addNote,
        const Icon(Icons.add_outlined));
  }

  searchNote() {
    myDialog(context, 'Buscar por título', textController, goSearchByTitlePage,
        const Icon(Icons.search));
    textController.text = '';
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
                              goFilterByCategoryPage(categoryData['title']);
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

  void goSearchByTitlePage() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SearchByTitlePage(search: textController.text)));
  }

  void goFilterByCategoryPage(String search) {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FilterByCategory(search: search)));
  }

  void goProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  void goManageCategoriesPage() {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ManageCategories()));
  }

  void goManageFriendsPage() {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ManageFriends()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Samba'),
      ),
      drawer: MyDrawer(
        onProfileTap: goProfilePage,
        onSignOutTap: signOut,
        onManageCategoriesTap: goManageCategoriesPage,
        onManageFriendsTap: goManageFriendsPage,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('notes')
                          .where('owner', isEqualTo: currentUser.email)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                final note = snapshot.data!.docs[index];
                                return NoteWall(
                                    title: note['title'],
                                    noteId: note.id,
                                    body: note['body'],
                                    owner: note['owner'],
                                    color: note['color'],
                                    textColor: note['textColor']);
                              });
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Ha ocurrido un error'),
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SpeedDial(
                      buttonSize: const Size(55, 55),
                      switchLabelPosition: true,
                      icon: Icons.search,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      useRotationAnimation: true,
                      iconTheme: const IconThemeData(
                        color: Colors.white,
                        size: 35,
                      ),
                      elevation: 0,
                      overlayColor: Colors.black,
                      overlayOpacity: 0.4,
                      spacing: 30,
                      spaceBetweenChildren: 6,
                      children: [
                        SpeedDialChild(
                            child: const Icon(Icons.bookmark_outline),
                            label: 'Buscar por categoría',
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            onTap: showCategoryDialog),
                        SpeedDialChild(
                            child: const Icon(Icons.title),
                            label: 'Buscar por título',
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            onTap: () {
                              searchNote();
                            }),
                      ],
                    ),
                    MaterialButton(
                      shape: const CircleBorder(),
                      onPressed: uploadNote,
                      color: Theme.of(context).colorScheme.background,
                      padding: const EdgeInsets.all(15),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
