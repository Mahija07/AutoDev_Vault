import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController noteController = TextEditingController();
  final User? user = FirebaseAuth.instance.currentUser;

  void addNote() async {
    if (noteController.text.trim().isEmpty) return;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('notes')
        .add({
          'note': noteController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });
    noteController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final notesStream =
        FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('notes')
            .orderBy('timestamp', descending: true)
            .snapshots();

    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: noteController,
                    decoration: InputDecoration(hintText: 'Enter your note'),
                  ),
                ),
                IconButton(onPressed: addNote, icon: Icon(Icons.add)),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: notesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                final notes = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return ListTile(title: Text(notes[index]['note']));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
