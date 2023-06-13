import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samba/components/drawer.dart';
import 'package:samba/components/note_wall.dart';
import 'package:samba/components/alert_dialog.dart';
import 'package:samba/pages/manage_categories.dart';
import 'package:samba/pages/manage_friends.dart';
import 'package:samba/pages/profile_page.dart';
import 'package:samba/pages/search_by_title_page.dart';

//TODO
//! Categorías

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

  // Importar notas: obtener archivo
  void imoportNote() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      PlatformFile doc = result.files.first;
      try {
        final File file = File(doc.path!);
        final String title = doc.name.split('.')[0];
        final body = await file.readAsString();

        FirebaseFirestore.instance.collection('notes').add({
          'title': title,
          'owner': currentUser.email,
          'body': body,
          'color': 'Theme.of(context).canvasColor',
          'textColor': ' '
        });
      } catch (e) {
        // Capturar excepción
      }
    } else {
      // El usuario cancela la selección de archivo
    }
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

  void goSearchByTitlePage() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SearchByTitlePage(search: textController.text)));
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
        actions: [
          PopupMenuButton<int>(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).iconTheme.color,
            ),
            color: Theme.of(context).canvasColor,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      imoportNote();
                    },
                    child: const Expanded(child: Text('Importar archivo'))),
              ),
            ],
          ),
        ],
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
                    MaterialButton(
                      shape: const CircleBorder(),
                      onPressed: searchNote,
                      color: Theme.of(context).colorScheme.background,
                      padding: const EdgeInsets.all(15),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 25,
                      ),
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
