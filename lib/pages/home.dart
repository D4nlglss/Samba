import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samba/components/drawer.dart';
import 'package:samba/components/note_wall.dart';
import 'package:samba/components/alert_dialogs.dart';
import 'package:samba/pages/profile_page.dart';

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
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('notes').add({
        'title': textController.text,
        'owner': currentUser.email,
        'body': '',
        'category': [],
        'color': 'Theme.of(context).canvasColor',
        'textColor': ' '
      });
    }
    textController.text = '';
  }

  uploadNote() {
    addNoteDialog(context, 'Añadir nota', textController, addNote);
  }

  void goProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProfilePage()));
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
                                    body: note['body'],
                                    owner: note['owner'],
                                    category: note['category'],
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
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: MaterialButton(
                  shape: const CircleBorder(),
                  onPressed: uploadNote,
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
