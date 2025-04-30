import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';
import 'notes_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:confetti/confetti.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options:
          kIsWeb
              ? const FirebaseOptions(
                apiKey: "AIzaSyDgX8qo_RxswIqe1pcmkZ2UA4HgSd57z6U",
                authDomain: "autodev-vault.firebaseapp.com",
                projectId: "autodev-vault",
                storageBucket: "autodev-vault.firebasestorage.app",
                messagingSenderId: "578993882877",
                appId: "1:578993882877:web:18729eea24e85162afa094",
                measurementId: "G-QEZWXJHCZS",
              )
              : null,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Map<String, Map<String, String>> markdownSections = {
    'Model-Based Development': {
      'Overview': 'Model_Based_Development/mbd.md',
      'Simulink': 'Model_Based_Development/simulink.md',
      'Stateflow': 'Model_Based_Development/stateflow.md',
      'MIL': 'Model_Based_Development/MIL.md',
      'SIL': 'Model_Based_Development/SIL.md',
      'TLC': 'Model_Based_Development/TLC.md',
    },
    'AUTOSAR & RTE': {
      'Overview': 'AUTOSAR_RTE/autosar.md',
      'RTE': 'AUTOSAR_RTE/rte.md',
      'SWC': 'AUTOSAR_RTE/swc.md',
      'ComStack': 'AUTOSAR_RTE/comstack.md',
      'Interfaces': 'AUTOSAR_RTE/interfaces.md',
    },
    'Code-Based Development': {
      'Overview': 'Code_Based_Development/cbd.md',
      'Embedded C': 'Code_Based_Development/embeddedc.md',
      'Python': 'Code_Based_Development/python.md',
    },
    'Software Quality': {
      'Overview': 'Software_Quality/sqss.md',
      'ISO 26262': 'Software_Quality/ISO-26262.md',
      'MISRA-C': 'Software_Quality/MISRA_C_Guidelines.md',
      'Polyspace': 'Software_Quality/polyspace.md',
      'SonarQube': 'Software_Quality/sonarqube.md',
    },
    'Testing & Safety': {
      'GTest': 'Testing_Safety/gtest.md',
      'Testing': 'Testing_Safety/testing.md',
      'Safety Standards': 'Testing_Safety/safety_standards.md',
      'JIRA': 'Testing_Safety/jira.md',
    },
    'Tools & Scripting': {
      'Overview': 'Tools_Scripting/tools.md',
      'MATLAB': 'Tools_Scripting/matlab.md',
      'M-Scripting': 'Tools_Scripting/mscripting.md',
      'Git': 'Tools_Scripting/git.md',
      'VSCode': 'Tools_Scripting/vscode.md',
      'Linux': 'Tools_Scripting/linux.md',
    },
    'System Design': {
      'Overview': 'System_Design/system.md',
      'MagicDraw': 'System_Design/magicdraw_qna.md',
      'PREEvision': 'System_Design/preevision_qna.md',
      'Zonal Architecture': 'System_Design/zonal_architecture_qna.md',
    },
    'Vehicle Architecture': {
      'Overview': 'vehicle_architecture.md',
      'ECU': 'ECU.md',
      'ECU_Extract': 'ECU_Extract.md',
      'Communication Protocol': 'communication_protocols.md',
    },
    'coming soon': {'Coming Soon': 'coming_soon.md'},
  };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        } else if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: SelectableText('Error initializing Firebase'),
              ),
            ),
          );
        } else {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'AutoDev Vault',
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF121212),
              cardTheme: CardTheme(
                color: Colors.black.withOpacity(0.6),
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              textTheme: ThemeData.dark().textTheme.copyWith(
                titleLarge: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
                bodyMedium: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              colorScheme: const ColorScheme.dark(
                primary: Colors.pink,
                secondary: Colors.yellow,
                background: Color(0xFF121212),
              ),
            ),
            home: HomePage(markdownSections: markdownSections),
            routes: {
              '/home':
                  (context) => HomePage(markdownSections: markdownSections),
            },
          );
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final Map<String, Map<String, String>> markdownSections;

  const HomePage({super.key, required this.markdownSections});

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SelectableText('AutoDev Vault')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: SelectableText(
                'Navigation',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ...markdownSections.entries.expand(
              (category) => [
                ExpansionTile(
                  leading: const Icon(Icons.folder),
                  title: Text(category.key),
                  children:
                      category.value.entries.map((entry) {
                        return ListTile(
                          title: Text(entry.key),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => MarkdownScreen(
                                      filename: entry.value,
                                      title: entry.key,
                                    ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('GitHub'),
              onTap: () => _launchURL('https://github.com/Mahija07'),
            ),
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('LinkedIn'),
              onTap: () => _launchURL('www.linkedin.com/in/mahija07/'),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.black12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SelectableText(
                    'Welcome to AutoDev Vault 🚗🤖',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(height: 12),
                  SelectableText(
                    'This app is your companion for exploring and mastering the Automotive Software Development domain. Whether you’re into Model-Based Design, AUTOSAR, Safety, or Testing — it’s all here.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  SelectableText(
                    '🔧 Key Areas Covered:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(height: 8),
                  SelectableText(
                    '• Model-Based Development (Simulink, Stateflow, MIL/SIL)',
                  ),
                  SelectableText('• AUTOSAR & RTE'),
                  SelectableText('• Embedded C and Code-Based Development'),
                  SelectableText(
                    '• Software Quality (MISRA C, Polyspace, ISO 26262)',
                  ),
                  SelectableText('• Testing Tools (GTest, JIRA)'),
                  SelectableText('• System Design (MagicDraw, PREEvision)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // 🚀 Lottie Animation Instead of Image
          Lottie.asset(
            'assets/animations/Animation.json',
            height: 300,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 32),
          const Center(
            child: SelectableText(
              'Made with ❤️ by Mahija',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

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
        title: const SelectableText('My Bookmarks ✨'),
        actions: [
          if (notes.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever),
              tooltip: 'Clear All',
              onPressed: clearAllNotes,
            ),
        ],
      ),
      body:
          notes.isEmpty
              ? const Center(
                child: SelectableText(
                  'No bookmarks yet! 📚',
                  style: TextStyle(color: Colors.white70),
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

class MarkdownScreen extends StatelessWidget {
  final String filename;
  final String title;

  const MarkdownScreen({
    super.key,
    required this.filename,
    required this.title,
  });

  Future<String> loadMarkdown() async {
    return await rootBundle.loadString('assets/md/$filename');
  }

  Future<void> saveToNotes(BuildContext context, String text) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notes = prefs.getStringList('notes') ?? [];
    notes.add(text);
    await prefs.setStringList('notes', notes);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: SelectableText('Added to Notes 📒')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadMarkdown(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: const Center(
              child: SelectableText('Error loading markdown file'),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: Markdown(
              data: snapshot.data!,
              selectable: true,
              styleSheet: MarkdownStyleSheet.fromTheme(
                Theme.of(context).copyWith(
                  textTheme: Theme.of(context).textTheme.copyWith(
                    bodyLarge: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    bodyMedium: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
            floatingActionButton: Builder(
              builder:
                  (context) => FloatingActionButton.extended(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user == null) {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );

                        if (result != 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: SelectableText(
                                'You must log in to save bookmarks!',
                              ),
                            ),
                          );
                          return;
                        }
                      }

                      String? noteText = await showDialog<String>(
                        context: context,
                        builder: (context) {
                          TextEditingController controller =
                              TextEditingController();
                          return AlertDialog(
                            title: const SelectableText('Add a Bookmark ✍️'),
                            content: TextField(
                              controller: controller,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                hintText: 'Write a short note...',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed:
                                    () =>
                                        Navigator.pop(context, controller.text),
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

                        // 🎉 Show confetti after saving
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) {
                            ConfettiController _controllerCenter =
                                ConfettiController(
                                  duration: const Duration(seconds: 2),
                                );
                            _controllerCenter.play(); // Start the confetti!

                            Future.delayed(const Duration(seconds: 2), () {
                              _controllerCenter.stop();
                              Navigator.of(context).pop(); // Auto close dialog
                            });

                            return Center(
                              child: ConfettiWidget(
                                confettiController:
                                    _controllerCenter, // 💖 Must provide controller
                                blastDirectionality:
                                    BlastDirectionality.explosive,
                                shouldLoop: false,
                                numberOfParticles: 30,
                                colors: const [
                                  Colors.pinkAccent,
                                  Colors.yellow,
                                  Colors.redAccent,
                                ],
                                gravity: 0.3,
                                emissionFrequency: 0.05,
                                blastDirection: 0,
                              ),
                            );
                          },
                        );

                        bool goToNotes =
                            await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const SelectableText(
                                      'Bookmark Saved! 📚',
                                    ),
                                    content: const SelectableText(
                                      'Do you want to view your bookmarks now?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, false),
                                        child: const SelectableText(
                                          'No, stay here',
                                        ),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.pop(context, true),
                                        child: const SelectableText(
                                          'Yes, show bookmarks',
                                        ),
                                      ),
                                    ],
                                  ),
                            ) ??
                            false;

                        if (goToNotes) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NotesScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: SelectableText(
                                'Bookmark saved successfully! ✅',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    label: const SelectableText('Bookmark Title'),
                    icon: const Icon(Icons.bookmark_add),
                    backgroundColor: Colors.pink,
                  ),
            ),
          );
        }
      },
    );
  }
}
