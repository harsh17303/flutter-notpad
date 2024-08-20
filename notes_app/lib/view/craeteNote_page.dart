import 'package:flutter/material.dart';
import 'package:notes_app/JsonModels/note_model.dart';
import 'package:notes_app/SQLite/sqlite.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CraeteNote extends StatefulWidget {
  const CraeteNote({super.key});

  @override
  State<CraeteNote> createState() => _CraeteNoteState();
}

class _CraeteNoteState extends State<CraeteNote> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final dbHelper = DatabaseHelper();
  String username = "";

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString('username');
    setState(() {
      username = storedUsername ?? "Unknown User";
    });
  }

  Future<void> _createNote() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isNotEmpty && content.isNotEmpty && username.isNotEmpty) {
      final newNote = NoteModel(
        noteTitle: title,
        noteContent: content,
        createdAt: DateTime.now().toIso8601String(), // Assuming you store the created date
      );

      await dbHelper.createNote(newNote, username); // Pass username as the second argument

      Navigator.pop(context); // Return to the previous page
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Note")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createNote,
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}


