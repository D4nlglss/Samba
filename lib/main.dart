import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:samba/firebase_options.dart';
import 'package:samba/themes/dark.dart';
import 'package:samba/themes/light.dart';

import 'auth/auth.dart';

// Función principal
void main() async {
  // Se inicializan las dependencias
  WidgetsFlutterBinding.ensureInitialized();
  // Splash screen
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Bloquear rotación de la pantalla
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Barra de navegación transparente
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(const MyApp());
}

// Clase principal
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Se preparan los temas
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const AuthPage(),
    );
  }
}
