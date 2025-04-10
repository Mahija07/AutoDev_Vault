import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoDev Vault',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
        useMaterial3: true,
      ),
      home: HomePage(fileName: 'MBD.md'),
    );
  }
}

class HomePage extends StatefulWidget {
  final String fileName;

  HomePage({required this.fileName});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> markdownContent;

  @override
  void initState() {
    super.initState();
    markdownContent = loadMarkdownFromWeb(widget.fileName);
  }

  Future<String> loadMarkdownFromWeb(String fileName) async {
    final url =
        'https://mahija07.github.io/Automotive_MBD_questionnaire/$fileName';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '# Error\nCould not load the content.';
    }
  }

  void navigateTo(String fileName) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(fileName: fileName)),
    );
  }

  void launchLinkedIn() async {
    final uri = Uri.parse('https://www.linkedin.com/in/mahijaverma/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    https: //github.com/Mahija07/Automotive_MBD_questionnaire/tree/Model_Based_Development_QnA/docs

    return Scaffold(
      appBar: AppBar(
        title: Text('AutoDev Vault 💡'),
        backgroundColor: Colors.pinkAccent,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.pink),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔧 Navigation',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 10),
                  Text('by Mahija 💖', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            ListTile(
              title: Text('Model-Based Dev'),
              onTap: () => navigateTo('MBD.md'),
            ),
            ListTile(
              title: Text('Code-Based Dev'),
              onTap: () => navigateTo('CBD.md'),
            ),
            ListTile(
              title: Text('Stateflow Q&A'),
              onTap: () => navigateTo('Stateflow.md'),
            ),
            ListTile(
              title: Text('GTest Q&A'),
              onTap: () => navigateTo('GTest.md'),
            ),
            ListTile(
              title: Text('Feedback (LinkedIn)'),
              onTap: () => navigateTo('feedback.md'),
            ),
          ],
        ),
      ),
      body: FutureBuilder<String>(
        future: markdownContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.pink));
          } else if (snapshot.hasError) {
            return Center(child: Text('❌ Error loading content'));
          } else {
            return Markdown(
              data: snapshot.data!,
              styleSheet: MarkdownStyleSheet(
                h1: TextStyle(color: Colors.red, fontSize: 24),
                p: TextStyle(fontSize: 16),
                listBullet: TextStyle(color: Colors.deepPurple),
              ),
            );
          }
        },
      ),
    );
  }
}
