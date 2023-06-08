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

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('users');

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
          //? Aceptar
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

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        title: Text('Editar $field'),
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
          //? Aceptar
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
                  Navigator.of(context).pop(newValue);
                },
                child: const Icon(Icons.done),
              ),
            ),
          ),
        ],
      ),
    );

    //? Cambiar valor
    if (newValue.trim().isNotEmpty) {
      await usersCollection.doc(currentUser.email).update({field: newValue});
    }
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
                    child: Text('Detalles de mi cuenta'),
                  ),
                  MyTextBox(
                    text: userData['username'],
                    sectionName: 'nombre de usuario',
                    onPressed: () => editField('username'),
                  ),
                  MyTextBox(
                    text: '*******',
                    sectionName: 'contraseña',
                    onPressed: () => changePwdDialog(),
                  ),
                  const SizedBox(height: 50),
                  const Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Text('Notas'),
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
