import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Widget de amigos
class Friend extends StatelessWidget {
  final String email;
  final Function()? onTap;

  const Friend({super.key, required this.email, this.onTap});

  Future<String> _getFriendName() async {
    final friend =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    return await friend['username'];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
        padding: const EdgeInsets.only(top: 25, bottom: 25),
        child: Column(
          children: [
            FutureBuilder<String>(
              future:
                  _getFriendName(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Text('${snapshot.data}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 22));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(email,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
      ),
    );
  }
}
