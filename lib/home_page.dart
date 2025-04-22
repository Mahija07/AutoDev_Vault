import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

import 'notes_screen.dart'; // Notes screen to view saved notes

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<bool> ensureLoggedIn(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser == null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );

      if (result != 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login required to save notes.')),
        );
        return false;
      }
    }
    return true;
  }

  Future<void> saveNote(BuildContext context) async {
    bool loggedIn = await ensureLoggedIn(context);
    if (!loggedIn) return;

    // Ask user to write a custom note
    String? noteText = await showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add a Note ✍️'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Write something to save...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Cancel
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed:
                  () => Navigator.pop(
                    context,
                    controller.text,
                  ), // Save and return
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    if (noteText != null && noteText.trim().isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      List<String> notes = prefs.getStringList('notes') ?? [];
      notes.add(noteText.trim());
      await prefs.setStringList('notes', notes);

      // After saving, ask if user wants to go to Notes page
      bool goToNotes =
          await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Bookmark Saved! 📚'),
                  content: const Text(
                    'Do you want to view your bookmarks now?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('No, Stay Here'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Yes, Show Bookmarks!'),
                    ),
                  ],
                ),
          ) ??
          false;

      if (goToNotes) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotesScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bookmark saved successfully! 🏷️')),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No note saved 🚫')));
    }
  }

  void openNotes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => openNotes(context),
              icon: const Icon(Icons.bookmark),
              label: const Text('View My Notes'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => saveNote(context),
              icon: const Icon(Icons.save),
              label: const Text('Save Something'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => saveNote(context),
        label: const Text('Add to Notes ✨'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
      ),
    );
  }
}
