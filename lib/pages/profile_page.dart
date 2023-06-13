import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samba/components/text_box.dart';

import '../components/snackbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// Pantalla de gestión de perfil
class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  // Confirmar cambio de contraseña
  void changePwdDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: const Text(
          'Cambiar contraseña',
          textAlign: TextAlign.center,
        ),
        content: const Text(
          '¿De verdad quieres cambiar tu contraseña?',
          textAlign: TextAlign.center,
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
                  restorePwd();
                },
                child: const Text(
                  'Cambiar',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Restablecer contraseña
  void restorePwd() async {
    String fail = '';
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) => const Center(child: CircularProgressIndicator())),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: currentUser.email!);
      if (context.mounted) {
        displayMessage(
            'Se ha enviado un correo de recuperación, ¡Revisa en spam!',
            context,
            Colors.green.shade400);
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      fail = e.message!;
      Navigator.pop(context);
      displayMessage(fail, context, Colors.redAccent);
    }
  }

  // Editar nombre de usuario
  Future<void> editUsername() async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: const Text('Editar nombre de usuario'),
        content: TextField(
          autofocus: true,
          cursorColor: Theme.of(context).colorScheme.primary,
          textInputAction: TextInputAction.done,
          style: const TextStyle(
            fontSize: 17,
          ),
          onChanged: (value) {
            newValue = value;
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).canvasColor,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
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
                  Navigator.of(context).pop(newValue);
                },
                child: const Icon(Icons.done),
              ),
            ),
          ),
        ],
      ),
    );

    if (newValue.trim().isNotEmpty) {
      await usersCollection
          .doc(currentUser.email)
          .update({'username': newValue});
    }
  }

  // Confirmar eliminación de la cuenta
  void confirmDeleteAccount() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: const Center(
              child: Text('Borrar Cuenta'),
            ),
            content: Text(
              '¡Estás a punto de eliminar tu cuenta!\nEsta acción no se puede deshacer',
              style: TextStyle(
                color: Colors.red[400],
              ),
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
                      deleteAccount();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('¡Sí, quiero borrar mi cuenta!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ],
          );
        });
  }

  // Borrar cuenta
  //? Se borran todas las referencias y el propio usuario de firestore
  //? y luego de firebase auth
  void deleteAccount() async {
    // Notas del usuario
    final userNotes = await FirebaseFirestore.instance
        .collection('notes')
        .where('owner', isEqualTo: currentUser.email)
        .get();

    // Borrar notas
    for (var note in userNotes.docs) {
      // Categorías de la nota
      final categories = await FirebaseFirestore.instance
          .collection('notes')
          .doc(note.id)
          .collection('categories')
          .get();
      // Borrar categorías de la nota
      for (var category in categories.docs) {
        await FirebaseFirestore.instance
            .collection('notes')
            .doc(note.id)
            .collection('categories')
            .doc(category.id)
            .delete();
      }
      await FirebaseFirestore.instance
          .collection('notes')
          .doc(note.id)
          .delete();
    }
    // Amigos del usuario
    final userFriends = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('friends')
        .get();

    // Borrar amigos del usuario
    for (var friend in userFriends.docs) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .collection('friends')
          .doc(friend.id)
          .delete();
    }
    // Categorías del usuario
    final userCategories = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('categories')
        .get();

    // Borrar categorias del usuario
    for (var category in userCategories.docs) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.email)
          .collection('categories')
          .doc(category.id)
          .delete();
    }

    // Borrar usuario de las listas de amigos
    final users = await FirebaseFirestore.instance.collection('users').get();

    for (var user in users.docs) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .collection('friends')
          .doc(currentUser.email)
          .delete();
    }

    // Borrar usuario
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .delete();

    // Eliminar usuario de FirebaseAuth
    FirebaseAuth.instance.currentUser!.delete();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Tu Perfil'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.email)
              .snapshots(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListView(
                children: [
                  const SizedBox(height: 50),
                  const Icon(Icons.person, size: 72),
                  const SizedBox(height: 10),
                  Text(
                    currentUser.email!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text('Detalles de la cuenta'),
                  ),
                  MyTextBox(
                    text: userData['username'],
                    sectionName: 'nombre de usuario',
                    onPressed: () => editUsername(),
                  ),
                  MyTextBox(
                    text: '*******',
                    sectionName: 'contraseña',
                    onPressed: () => changePwdDialog(),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width * 0.55,
                      height: MediaQuery.of(context).size.width * 0.22,
                      color: Theme.of(context).canvasColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onPressed: confirmDeleteAccount,
                      child: Text('Eliminar cuenta',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.red[400],
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Ha ocurrido un error'),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          })),
    );
  }
}
