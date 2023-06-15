import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:samba/auth/change_auth_page.dart';
import 'package:samba/pages/home.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isDeviceConnectedAtStart = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  @override
  dispose() {
    subscription.cancel();
    super.dispose;
  }

// Comprueba si se ha perdido la conexión a internet
//! No funciona si se entra a la app sin conexión
  getConnectivity() {
    subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) async {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (!isDeviceConnected && isAlertSet == false) {
          showNoConnectionDialog();
          setState(() => isAlertSet = true);
        }
      },
    );
  }

  // Diálogo que bloquea la app hasta recuperar la conexión
  showNoConnectionDialog() => showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            content: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.wifi_off,
                  color: Colors.redAccent,
                  size: 135,
                ),
                Text('¡Vaya!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Parece que tu dispositivo no tiene conexión a internet ...',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              const Divider(),
              Center(
                child: MaterialButton(
                  color: Theme.of(context).colorScheme.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    setState(() => isAlertSet = false);
                    isDeviceConnected =
                        await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected && isAlertSet == false) {
                      showNoConnectionDialog();
                      setState(() => isAlertSet = true);
                    }
                  },
                  child: const Text('Reintentar'),
                ),
              ),
            ],
          ),
        ),
      );

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
