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
              body: Center(child: Text('Error initializing Firebase')),
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
      appBar: AppBar(title: const Text('AutoDev Vault')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
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
              onTap:
                  () => _launchURL('https://www.linkedin.com/in/mahija-verma/'),
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
                  Text(
                    'Welcome to AutoDev Vault 🚗🤖',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'This app is your companion for exploring and mastering the Automotive Software Development domain. Whether you’re into Model-Based Design, AUTOSAR, Safety, or Testing — it’s all here.',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '🔧 Key Areas Covered:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pinkAccent,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Model-Based Development (Simulink, Stateflow, MIL/SIL)',
                  ),
                  Text('• AUTOSAR & RTE'),
                  Text('• Embedded C and Code-Based Development'),
                  Text('• Software Quality (MISRA C, Polyspace, ISO 26262)'),
                  Text('• Testing Tools (GTest, JIRA)'),
                  Text('• System Design (MagicDraw, PREEvision)'),
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
            child: Text(
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

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Added to Notes 📒')));
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
            body: const Center(child: Text('Error loading markdown file')),
          );
        } else {
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: Markdown(
              data: snapshot.data!,
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
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => saveToNotes(context, title),
              label: const Text('Bookmark Title'),
              icon: const Icon(Icons.bookmark_add),
              backgroundColor: Colors.pink,
            ),
          );
        }
      },
    );
  }
}
