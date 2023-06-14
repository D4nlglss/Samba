import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samba/components/box_shadow.dart';
import 'package:samba/components/button.dart';
import 'package:samba/components/text_field.dart';

import '../components/snackbar.dart';

class RestorePage extends StatefulWidget {
  final Function()? onTap;
  const RestorePage({super.key, required this.onTap});

  @override
  State<RestorePage> createState() => _RestorePageState();
}

// Pantalla para restaurar la contraseña
class _RestorePageState extends State<RestorePage> {
  final emailController = TextEditingController();

  // Restaurar contraseña
  void restorePwd() async {
    String fail = '';
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: ((context) => const Center(child: CircularProgressIndicator())),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      if (context.mounted) {
        emailController.text = '';
        displayMessage(
            'Se ha enviado un correo de recuperación, ¡Revisa en spam!',
            context,
            Colors.green.shade400);
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      fail = e.message!;
      Navigator.pop(context);
      if (fail.contains('empty or null')) {
        fail = '¡No has introducido ningún correo electrónico!';
      } else if (fail.contains('email address is badly formatted')) {
        fail = 'El correo electrónico no es válido.';
      } else if (fail.contains('A network error')) {
        fail = 'Parece que el dispositivo no tiene conexión';
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
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: height * 0.22,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.elliptical(200, 0),
                        bottomRight: Radius.elliptical(200, 100)),
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: myBoxShadow()),
              ),
              Container(
                height: height * 0.22,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.elliptical(200, 100),
                        topRight: Radius.elliptical(200, 0)),
                    color: Theme.of(context).colorScheme.background,
                    boxShadow: myBoxShadow()),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: height * 0.05,
                ),
                Text(
                  "Samba",
                  style: GoogleFonts.satisfy(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                const Text(
                  "Introduce tu correo electrónico para recuperar tu contraseña",
                  textAlign: TextAlign.center,
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
                  height: 40,
                ),
                MyButton(onPressed: restorePwd, text: 'Recuperar'),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    "Volver",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: height * 0.07,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
