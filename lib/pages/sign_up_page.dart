import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samba/components/box_shadow.dart';
import 'package:samba/components/button.dart';
import 'package:samba/components/text_field.dart';

import '../components/snackbar.dart';

class SignUpPage extends StatefulWidget {
  final Function()? onTap;
  const SignUpPage({super.key, required this.onTap});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUp() async {
    String fail = '';
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) => const Center(child: CircularProgressIndicator())),
    );
    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      displayMessage('Las contraseñas no coinciden', context, Colors.redAccent);
      return;
    }
    if (emailController.text == '' ||
        passwordController.text == '' ||
        confirmPasswordController.text == '') {
      Navigator.pop(context);
      displayMessage('Faltan campos por completar', context, Colors.redAccent);
      return;
    }
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.email)
          .set({
        'username': emailController.text.split('@')[0],
        'categories':[],
      });

      if (context.mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      fail = e.message!;
      Navigator.pop(context);
      if (emailController.text == '' ||
          passwordController.text == '' ||
          confirmPasswordController.text == '') {
        fail = 'Faltan campos por completar';
      } else if (fail.contains('address is badly formatted')) {
        fail = 'El correo electrónico no es válido.';
      } else if (fail.contains('password is invalid')) {
      } else if (fail.contains('address is already in use')) {
        fail = 'El correo electrónico ya está en uso';
      } else if (fail.contains('at least 6')) {
        fail = 'La contraseña debe tener 6 caracteres como mínimo';
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
            alignment: Alignment.topCenter,
            child: Container(
              height: height * 0.8,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.elliptical(200, 50),
                    bottomLeft: Radius.elliptical(200, 50)),
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: myBoxShadow(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  children: [
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
                      "¡Crea tu cuenta de Samba!",
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
                        action: TextInputAction.next,
                        hintText: 'Contraseña',
                        obscureText: true),
                    const SizedBox(
                      height: 20,
                    ),
                    MyTextField(
                        controller: confirmPasswordController,
                        action: TextInputAction.done,
                        hintText: 'Confirma la contraseña',
                        obscureText: true),
                    const SizedBox(
                      height: 40,
                    ),
                    MyButton(onPressed: signUp, text: 'Registrarme'),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("¿Ya tienes una cuenta?"),
                        const SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: Text(
                            "Inicia sesión",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
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
