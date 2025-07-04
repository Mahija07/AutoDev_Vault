import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  // Load bookmarks from shared preferences
  _loadBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bookmarks = prefs.getStringList('bookmarks') ?? [];
    });
  }

  // Save bookmarks to shared preferences
  _saveBookmark(String bookmark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bookmarks.add(bookmark);
    await prefs.setStringList('bookmarks', bookmarks);
    setState(() {});
  }

  // Remove a bookmark
  _removeBookmark(String bookmark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bookmarks.remove(bookmark);
    await prefs.setStringList('bookmarks', bookmarks);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmark Example'),
        actions: [
          IconButton(
            icon: Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkPage(bookmarks, _removeBookmark)),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          String item = 'Item $index';
          return ListTile(
            title: Text(item),
            trailing: IconButton(
              icon: Icon(
                bookmarks.contains(item) ? Icons.bookmark : Icons.bookmark_border,
                color: bookmarks.contains(item) ? Colors.blue : null,
              ),
              onPressed: () {
                if (bookmarks.contains(item)) {
                  _removeBookmark(item);
                } else {
                  _saveBookmark(item);
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class BookmarkPage extends StatelessWidget {
  final List<String> bookmarks;
  final Function(String) removeBookmark;

  BookmarkPage(this.bookmarks, this.removeBookmark);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bookmarked Items')),
      body: ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          String bookmark = bookmarks[index];
          return ListTile(
            title: Text(bookmark),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                removeBookmark(bookmark);
              },
            ),
          );
        },
      ),
    );
  }
}
