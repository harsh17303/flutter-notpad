import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:notes_app/JsonModels/note_model.dart';
import 'package:notes_app/JsonModels/users.dart';

class DatabaseHelper {
  final databaseName = "notes.db";

  String noteTable = '''
CREATE TABLE notes(
  noteId INTEGER PRIMARY KEY AUTOINCREMENT,
  noteTitle TEXT,
  noteContent TEXT,
  createdAt TEXT,
  username TEXT,
  isCompleted INTEGER DEFAULT 0
)
''';

  // User table creation query with the new column profilepic_url
  String users = '''
CREATE TABLE users (
  usrId INTEGER PRIMARY KEY AUTOINCREMENT, 
  usrName TEXT UNIQUE, 
  usrPassword TEXT,
  profilepic_url STRING DEFAULT ''
)
''';

  // Initialize the database
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(
      path,
      version: 3, // Incremented version for schema update
      onCreate: (db, version) async {
        await db.execute(users);
        await db.execute(noteTable);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          // Add the new column if it does not exist
          await db.execute('''
            ALTER TABLE users 
            ADD COLUMN profilepic_url TEXT DEFAULT ''
          ''');
        }
      },
    );
  }

  // Login method
  Future<bool> login(Users user) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "SELECT * FROM users WHERE usrName = ? AND usrPassword = ?",
        [user.usrName, user.usrPassword]
    );
    return result.isNotEmpty;
  }

  // Sign up method
  Future<int> signup(Users user) async {
    final Database db = await initDB();
    return db.insert('users', user.toMap());
  }

  // Method to check if a username already exists in the database
  Future<bool> usernameExists(String username) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        'SELECT COUNT(*) FROM users WHERE usrName = ?',
        [username]
    );
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count > 0;
  }

  // Fetch username by username
  Future<String?> fetchUsernameByUsername(String username) async {
    final Database db = await initDB();
    var result = await db.query(
        'users',
        columns: ['usrName'],
        where: 'usrName = ?',
        whereArgs: [username]
    );
    if (result.isNotEmpty) {
      return result.first['usrName'] as String?;
    }
    return null;
  }

  // CRUD Methods

  // Create Note
  Future<void> createNote(NoteModel note, String username) async {
    final db = await initDB();
    await db.insert(
      'notes',
      note.toMap()..['username'] = username, // Add username to the map
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get notes by username
  Future<List<NoteModel>> getNotes(String username) async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'username = ?',
      whereArgs: [username],
    );

    return List.generate(maps.length, (i) {
      return NoteModel.fromMap(maps[i]);
    });
  }

  // Delete Note
  Future<int> deleteNote(int id) async {
    final Database db = await initDB();
    return db.delete('notes', where: 'noteId = ?', whereArgs: [id]);
  }

  // Update Note content
  Future<int> updateNote(String title, String content, int noteId) async {
    final Database db = await initDB();
    return db.rawUpdate(
        'UPDATE notes SET noteTitle = ?, noteContent = ? WHERE noteId = ?',
        [title, content, noteId]
    );
  }

  // Update Note completion status
  Future<int> updateNoteCompletionStatus(int noteId, bool isCompleted) async {
    final db = await initDB();
    return await db.update(
        'notes',
        {'isCompleted': isCompleted ? 1 : 0},
        where: 'noteId = ?',
        whereArgs: [noteId]
    );
  }

  Future<String?> fetchProfilePic(String username) async {
    final db = await initDB();
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      columns: ['profilepic_url'],
      where: 'usrName = ?',
      whereArgs: [username],
    );
    if (result.isNotEmpty) {
      return result.first['profilepic_url'] as String?;
    }
    return null;
  }

  Future<int> updateProfilePic(String username, String profilePicUrl) async {
    final db = await initDB();
    return db.update(
      'users',
      {'profilepic_url': profilePicUrl},
      where: 'usrName = ?',
      whereArgs: [username],
    );
  }
}
