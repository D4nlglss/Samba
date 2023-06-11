import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samba/components/friends.dart';
import 'package:samba/components/snackbar.dart';
import 'package:samba/components/text_field.dart';

class ManageFriends extends StatefulWidget {
  const ManageFriends({super.key});

  @override
  State<ManageFriends> createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageFriends> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  void findFriend(String email, BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) => const Center(child: CircularProgressIndicator())),
    );

    final friend =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (friend.exists && currentUser.email != email) {
      addFriend(email);
    }
    if (email == currentUser.email) {
      // ignore: use_build_context_synchronously
      displayMessage(
          'Puede ser normal no tener amigos pero añadirse a uno mismo es un poco triste',
          context,
          Colors.redAccent);
    }
    if (!friend.exists) {
      // ignore: use_build_context_synchronously
      displayMessage('No existe ningún usuario con esa dirección de correo',
          context, Colors.redAccent);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void addFriend(String email) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('friends')
        .doc(email)
        .set({
      'email': email,
    });
  }

  void deleteFriend(String email) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .collection('friends')
        .doc(email)
        .delete();
  }

  void addFriendDialog(BuildContext context) {
    var controller = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Center(child: Text('Añadir amigo')),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyTextFieldII(
                      controller: controller,
                      action: TextInputAction.done,
                      hintText: 'Correo electrónico',
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
                          findFriend(controller.text, context);
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

  void confirmDeleteFriend(BuildContext context, String email) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            title: const Center(
              child: Text('Eliminar Amigo'),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '¿Quieres eliminar a este amigo?',
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
                  padding: const EdgeInsets.only(top: 25, bottom: 25),
                  child: Text(email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.redAccent)),
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
                      borderRadius: BorderRadius.circular(7),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      deleteFriend(email);
                    },
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Tus Amigos'),
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
                                final friendData =
                                    doc.data() as Map<String, dynamic>;
                                return Friends(
                                    email: friendData['email'],
                                    onTap: () {
                                      confirmDeleteFriend(
                                          context, friendData['email']);
                                    });
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
                    addFriendDialog(context);
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
