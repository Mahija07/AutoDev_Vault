import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = prefs.getStringList('notes') ?? [];
    });
  }

  Future<void> deleteNoteAt(int index) async {
    final prefs = await SharedPreferences.getInstance();
    notes.removeAt(index);
    await prefs.setStringList('notes', notes);
    loadNotes();
  }

  Future<void> clearAllNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('notes');
    loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes ✨'),
        actions: [
          if (notes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Clear All Notes',
              onPressed: () async {
                bool confirm = await showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('Clear All Notes?'),
                        content: const Text(
                          'Are you sure you want to delete all notes?',
                        ),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context, false),
                          ),
                          TextButton(
                            child: const Text('Delete'),
                            onPressed: () => Navigator.pop(context, true),
                          ),
                        ],
                      ),
                );
                if (confirm) {
                  await clearAllNotes();
                }
              },
            ),
        ],
      ),
      body:
          notes.isEmpty
              ? const Center(
                child: Text(
                  'No notes yet! Bookmark some topics 🚀',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
              )
              : ListView.separated(
                itemCount: notes.length,
                separatorBuilder:
                    (context, index) => const Divider(color: Colors.white24),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.bookmark,
                      color: Colors.pinkAccent,
                    ),
                    title: Text(notes[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => deleteNoteAt(index),
                    ),
                  );
                },
              ),
    );
  }
}
