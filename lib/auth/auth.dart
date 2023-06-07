import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samba/auth/sign_in_or_sign_up.dart';
import 'package:samba/pages/home.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //El usuario tiene la sesión abierta
          if (snapshot.hasData) {
            return const HomePage();
          }
          //EL usuario no ha iniciado sesión
          else {
            return const SignInOrSignUp();
          }
        },
      ),
    );
  }
}
