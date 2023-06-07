import 'package:flutter/cupertino.dart';
import 'package:samba/pages/login_page.dart';
import 'package:samba/pages/sign_in_page.dart';

class SignInOrSignUp extends StatefulWidget {
  const SignInOrSignUp({super.key});

  @override
  State<SignInOrSignUp> createState() => _SignInOrSignUpState();
}

class _SignInOrSignUpState extends State<SignInOrSignUp> {
  // Por defecto, se devuelve la pantalla de Inicio de sesión
  bool showLoginPage = true;

  // Función para alternar entre la pantalla de Inicio de sesión y registro
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return SignInPage(onTap: togglePages);
    } else {
      return SignUpPage(onTap: togglePages);
    }
  }
}
