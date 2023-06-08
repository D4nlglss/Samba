import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samba/components/box_shadow.dart';
import 'package:samba/components/button.dart';
import 'package:samba/components/text_field.dart';

import '../components/snackbar.dart';

class SignInPage extends StatefulWidget {
  final Function()? onTap;
  final Function()? onTapII;
  const SignInPage({super.key, required this.onTap, required this.onTapII});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async {
    String fail = '';
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) => const Center(child: CircularProgressIndicator())),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      fail = e.message!;
      Navigator.pop(context);
      if (fail.contains('empty or null')) {
        fail = '¡Faltan campos por completar!';
      } else if (fail.contains('email address is badly formatted')) {
        fail = 'El correo electrónico no es válido.';
      } else if (fail.contains('password is invalid')) {
        fail = 'La contraseña no es correcta.';
      } else if (fail.contains('no user record corresponding')) {
        fail = 'No existe un usuario con ese correo electrónico';
      }
      displayMessage(fail, context, Colors.redAccent);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Expanded(
            child: Container(color: Theme.of(context).colorScheme.background),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: height * 0.8,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.elliptical(200, 50),
                    topLeft: Radius.elliptical(200, 50)),
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: myBoxShadow(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Center(
                      child: Text(
                        "Samba",
                        style: GoogleFonts.satisfy(
                          fontSize: 70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    const Text(
                      "¡Hola!, me alegro de verte",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                        controller: emailController,
                        action: TextInputAction.next,
                        hintText: 'Correo electrónico',
                        obscureText: false),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                        controller: passwordController,
                        action: TextInputAction.done,
                        hintText: 'Contraseña',
                        obscureText: true),
                    const SizedBox(
                      height: 40,
                    ),
                    MyButton(onPressed: signIn, text: 'Iniciar sesión'),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿No tienes cuenta?"),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Regístrate",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: widget.onTapII,
                      child: Text(
                        "Recuperar contraseña",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
