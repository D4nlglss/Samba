import 'package:flutter/cupertino.dart';
import 'package:samba/pages/sign_in.dart';
import 'package:samba/pages/restore_page.dart';
import 'package:samba/pages/sign_up_page.dart';

class ChangeAuthPage extends StatefulWidget {
  const ChangeAuthPage({super.key});

  @override
  State<ChangeAuthPage> createState() => _ChangeAuthPageState();
}

class _ChangeAuthPageState extends State<ChangeAuthPage> {
  // Por defecto, se devuelve la pantalla de Inicio de sesión
  bool showSignUp = false;
  bool showRestore = false;

  // Función para alternar entre la pantalla de Inicio de sesión y registro
  void toggleSignUp() {
    setState(() {
      showSignUp = !showSignUp;
    });
  }

  // Función para alternar entre la pantalla de Inicio de sesión y recuperación
  void toggleRestore() {
    setState(() {
      showRestore = !showRestore;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignUp) {
      return SignUpPage(onTap: toggleSignUp);
    } else if (showRestore) {
      return RestorePage(onTap: toggleRestore);
    } else {
      return SignInPage(onTap: toggleSignUp, onTapII: toggleRestore);
    }
  }
}
