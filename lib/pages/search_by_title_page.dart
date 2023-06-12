import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:samba/components/note_wall.dart';

class SearchByTitlePage extends StatefulWidget {
  final String search;
  const SearchByTitlePage({super.key, required this.search});

  @override
  State<SearchByTitlePage> createState() => _SearchByTitlePageState();
}

class _SearchByTitlePageState extends State<SearchByTitlePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(' Resultados de ${widget.search}'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('notes')
                      .where('owner', isEqualTo: currentUser.email)
                      .where('title', isEqualTo: widget.search)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final note = snapshot.data!.docs[index];
                            return NoteWall(
                                title: note['title'],
                                noteId: note.id,
                                body: note['body'],
                                owner: note['owner'],
                                color: note['color'],
                                textColor: note['textColor']);
                          });
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Ha ocurrido un error'),
                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

