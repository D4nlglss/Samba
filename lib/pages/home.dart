import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:samba/components/drawer.dart';
import 'package:samba/components/note_wall.dart';
import 'package:samba/components/alert_dialog.dart';
import 'package:samba/pages/manage_categories.dart';
import 'package:samba/pages/manage_friends.dart';
import 'package:samba/pages/profile_page.dart';
import 'package:samba/pages/search_by_title_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

// Pantalla principal
class _HomeState extends State<HomePage> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose;
  }

// COmprueba si se ha perdido la conexión a internet
//! No funciona si se entra a la app sin conexión
  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && isAlertSet == false) {
          showNoConnectionDialog();
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  // Diálogo que bloquea la app hasta recuperar la conexión
  showNoConnectionDialog() => showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).canvasColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off,
                color: Colors.redAccent,
                size: 135,
              ),
              Text('¡Vaya!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                'Parece que tu dispositivo no tiene conexión a internet ...',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            const Divider(),
            Center(
              child: MaterialButton(
                color: Theme.of(context).colorScheme.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                onPressed: () async {
                  Navigator.pop(context, 'Cancel');
                  setState(() => isAlertSet = false);
                  isDeviceConnected =
                      await InternetConnectionChecker().hasConnection;
                  if (!isDeviceConnected && isAlertSet == false) {
                    showNoConnectionDialog();
                    setState(() => isAlertSet = true);
                  }
                },
                child: const Text('Reintentar'),
              ),
            ),
          ],
        ),
      );

  // Cerrar sesión
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  // Importar notas
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
        //? No hay que manejarla en mayor medida, simplemente si falla no hará nada
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
      textController.text = '';
    }
    textController.text = '';
  }

  // Añadir nota
  uploadNote() {
    myDialog(context, 'Añadir nota', textController, addNote,
        const Icon(Icons.add_outlined));
  }

  // Buscar nota
  searchNote() {
    myDialog(context, 'Buscar por título', textController, goSearchByTitlePage,
        const Icon(Icons.search));
    textController.text = '';
  }

  // Ir a la pantalla de resultados de búsqueda
  void goSearchByTitlePage() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SearchByTitlePage(search: textController.text)));
  }

  // Ir a la página de perfil
  void goProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ProfilePage()));
  }

  // Ir a la página de administrar caregorías
  void goManageCategoriesPage() {
    Navigator.pop(context);
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ManageCategories()));
  }

  // Ir a la página de administrar amigos
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
                    child:
                        // Se obtienen las notas del usuario actual
                        StreamBuilder(
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
