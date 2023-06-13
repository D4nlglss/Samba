import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samba/auth/change_auth_page.dart';
import 'package:samba/pages/home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //El usuario tiene la sesión iniciada
          if (snapshot.hasData) {
            return const HomePage();
          }
          //EL usuario no ha iniciado sesión
          else {
            return const ChangeAuthPage();
          }
        },
      ),
    );
  }
}
