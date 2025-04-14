import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:http/http.dart' as http;

class MarkdownScreen extends StatelessWidget {
  final String filename;
  final String title;

  const MarkdownScreen({
    super.key,
    required this.filename,
    required this.title,
  });

  Future<String> _loadMarkdownFromGitHub() async {
    final String baseUrl =
        'https://raw.githubusercontent.com/Mahija07/Automotive_MBD_questionnaire/Model_Based_Development_QnA/';
    final response = await http.get(Uri.parse(baseUrl + filename));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load markdown file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<String>(
        future: _loadMarkdownFromGitHub(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading content 😢\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            );
          } else {
            return Markdown(
              data: snapshot.data ?? '',
              styleSheet: MarkdownStyleSheet(
                h1: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                h2: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                p: const TextStyle(fontSize: 16),
                listBullet: const TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }
}
