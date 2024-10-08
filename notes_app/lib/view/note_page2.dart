import 'package:flutter/material.dart';
import 'package:notes_app/view/craeteNote_page.dart';

import '../JsonModels/note_model.dart';
import '../SQLite/sqlite.dart';

class NotePage2 extends StatefulWidget {
  const NotePage2({super.key});

  @override
  State<NotePage2> createState() => _NotePage2State();
}

class _NotePage2State extends State<NotePage2> {

  final DatabaseHelper dbHelper = DatabaseHelper();
  List<NoteModel> _notes=[];
  List<NoteModel> _pendingNotes=[];
  List<NoteModel> _completedNotes=[];

  void _filterNotes(){
    setState(() {
      _pendingNotes=_notes.where((note)=>!note.isCompleted).toList();
      _completedNotes=_notes.where((note)=> note.isCompleted).toList();
    });
  }

  Future<void> _updateNoteCompletionStatus(int noteId, bool isCompleted) async{
    await dbHelper.updateNoteCompletionStatus(noteId, isCompleted);
    _fetchNot();
  }

  void _fetchNot() {
    _filterNotes();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: Text("Note page 2",), centerTitle: true, backgroundColor: Colors.deepPurple,
          bottom: TabBar(
            tabs: [
              Tab(text: ('Pending'),),
              Tab(text: 'Completed',),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNoteList(_pendingNotes),
            _buildNoteList(_completedNotes),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => const CraeteNote()))
                .then((_) {
              _fetchNot(); // Refresh the notes list after returning from CreateNotePage
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
  Widget _buildNoteList (List<NoteModel> notes){
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note=notes[index];
        final noteId=note.noteId ?? 0;
        return Card(
          color: Colors.deepPurple,
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
          child: ListTile(
            leading: Checkbox(
              value: note.isCompleted,
              onChanged: (bool? value) async{
                _updateNoteCompletionStatus(noteId, value ?? false);
              },
            ),
            title: Text(note.noteTitle),
            subtitle: Text(note.noteContent, maxLines: 1, overflow: TextOverflow.ellipsis,),
          ),
        );
      },
    );
  }
}






























// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:notes_app/JsonModels/note_model.dart';
// import 'package:notes_app/SQLite/sqlite.dart';
// import 'package:notes_app/view/craeteNote_page.dart';
// import 'package:notes_app/view/login_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../JsonModels/note_list.dart';
//
// class NotePage extends StatefulWidget {
//   const NotePage({super.key});
//
//   @override
//   State<NotePage> createState() => _NotePageState();
// }
//
//
//
// class _NotePageState extends State<NotePage> {
//   String username = "Loading...";
//   final DatabaseHelper dbHelper = DatabaseHelper();
//   List<NoteModel> _notes = [];
//   List<NoteModel> _pendingNotes = [];
//   List<NoteModel> _completedNotes = [];
//   List<NoteList> _apiResponse=[];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAndDisplayUsername();
//
//     getHttp();
//
//   }
//
//   void getHttp() async {
//     try {
//       final response = await Dio().get(
//           "https://jsonplaceholder.typicode.com/todos");
//       print(response);
//       // if(response!=null){
//       if(response.statusCode==200){
//
//         // List< Map<String, dynamic>> res=jsonDecode();
//
//         final pars= response.data.forEach((val){
//           print(val);
//           NoteList.fromJson(val);
//         });
//         // print(pars);
//       }
//     }catch(e, stack) {
//       print(e);
//       print(stack);
//     }
//   }
//
//
//   Future<void> fetchAndDisplayUsername() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedUsername = prefs.getString('username');
//
//     if (storedUsername != null) {
//       setState(() {
//         username = storedUsername;
//       });
//       _fetchNotes();  // Fetch notes after getting username
//     } else {
//       setState(() {
//         username = "Username not found";
//       });
//     }
//   }
//
//   Future<void> _fetchNotes() async {
//     final notes = await dbHelper.getNotes(username);  // Pass the username
//     setState(() {
//       _notes = notes;
//     });
//     _filterNotes();
//   }
//
//   void _filterNotes() {
//     setState(() {
//       _pendingNotes = _notes.where((note) => !note.isCompleted).toList();
//       _completedNotes = _notes.where((note) => note.isCompleted).toList();
//     });
//   }
//
//   Future<void> _deleteNote(int id) async {
//     await dbHelper.deleteNote(id);
//     _fetchNotes(); // Refresh the list of notes
//   }
//
//   Future<void> _updateNoteCompletionStatus(int noteId, bool isCompleted) async {
//     await dbHelper.updateNoteCompletionStatus(noteId, isCompleted);
//     _fetchNotes(); // Refresh the list of notes
//   }
//
//   Future<void> _editNote(
//       BuildContext context, NoteModel note, String username) async {
//     final titleController = TextEditingController(text: note.noteTitle);
//     final contentController = TextEditingController(text: note.noteContent);
//
//     final result = await showDialog<String>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Edit Note'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: titleController,
//               decoration: const InputDecoration(labelText: 'Title'),
//             ),
//             TextField(
//               controller: contentController,
//               decoration: const InputDecoration(labelText: 'Content'),
//               maxLines: 5,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, 'Cancel'),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () async {
//               await dbHelper.updateNote(
//                   titleController.text, contentController.text, note.noteId!);
//               Navigator.pop(context, 'Save');
//             },
//             child: const Text('Save'),
//           ),
//         ],
//       ),
//     );
//
//     if (result == 'Save') {
//       _fetchNotes(); // Refresh the list of notes
//     }
//   }
//
//   Future<void> logout() async {
//     var sharedPref = await SharedPreferences.getInstance();
//     sharedPref.clear(); // Clear all shared preferences
//
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//           (Route<dynamic> route) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return false; // Prevent back navigation
//       },
//       child: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text(username),
//             centerTitle: false,
//             actions: [
//               ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   backgroundColor: Colors.deepPurple,
//                 ),
//                 onPressed: logout,
//                 label: const Text("Logout"),
//                 icon: const Icon(Icons.logout),
//               ),
//               const Padding(padding: EdgeInsets.symmetric(horizontal: 10))
//             ],
//             bottom: const TabBar(
//               tabs: [
//                 Tab(text: "Pending"),
//                 Tab(text: "Completed"),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               _buildNoteList(_pendingNotes),
//               _buildNoteList(_completedNotes),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton(
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(50)),
//             ),
//             onPressed: () {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (context) => const CraeteNote()))
//                   .then((_) {
//                 _fetchNotes(); // Refresh the notes list after returning from CreateNotePage
//               });
//             },
//             child: const Icon(Icons.add),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildNoteList(List<NoteModel> notes) {
//     return ListView.builder(
//       itemCount: notes.length,
//       itemBuilder: (context, index) {
//         final note = notes[index];
//         final noteId = note.noteId ?? 0;
//
//         return Card(
//           color: Colors.deepPurple,
//           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           child: ListTile(
//             leading: Checkbox(
//               value: note.isCompleted,
//               onChanged: (bool? value) async {
//                 await _updateNoteCompletionStatus(noteId, value ?? false);
//               },
//             ),
//             title: Text(note.noteTitle),
//             subtitle: Text(
//               note.noteContent,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.white),
//                   onPressed: () => _editNote(context, note, username),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.delete, color: Colors.white),
//                   onPressed: () {
//                     showDialog(context: context, builder: (BuildContext context){
//                       return AlertDialog(
//                         title: const Text('Confirm delete'),
//                         content: Text('Are you sure you want to delete ${note.noteTitle} note?'),
//                         actions: [
//                           TextButton(onPressed: (){
//                             Navigator.of(context).pop();
//                           }, child: const Text('Cancel'),
//                           ),
//
//                           TextButton(onPressed: (){
//                             _deleteNote(noteId);
//                             Navigator.of(context).pop();
//                           } , child: const Text('delete'),
//                           ),
//                         ],
//                       );
//                     });
//                   },
//                   // => _deleteNote(noteId),
//                 ),
//               ],
//             ),
//             onTap: () {
//               // Show the note details in a dialog
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return AlertDialog(
//                     title: Text(note.noteTitle),
//                     content: Text(note.noteContent),
//                     actions: [
//                       TextButton(
//                         onPressed: () => Navigator.of(context).pop(),
//                         child: const Text('Close'),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           _deleteNote(noteId);
//                         },
//                         child: const Text('Delete'),
//                       ),
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }
//
//
//
// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:notes_app/JsonModels/note_model.dart';
// import 'package:notes_app/SQLite/sqlite.dart';
// import 'package:notes_app/view/craeteNote_page.dart';
// import 'package:notes_app/view/login_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class NotePage extends StatefulWidget {
//   const NotePage({super.key});
//
//   @override
//   State<NotePage> createState() => _NotePageState();
// }
//
// class _NotePageState extends State<NotePage> {
//   String username = "Loading...";
//   final DatabaseHelper dbHelper = DatabaseHelper();
//   List<NoteModel> _notes = [];
//   List<NoteModel> _pendingNotes = [];
//   List<NoteModel> _completedNotes = [];
//
//   Map<int, bool> checkedStates = {};
//
//   @override
//   void initState() {
//     super.initState();
//     fetchAndDisplayUsername();
//   }
//
//   Future<void> fetchAndDisplayUsername() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? storedUsername = prefs.getString('username');
//
//     if (storedUsername != null) {
//       setState(() {
//         username = storedUsername;
//       });
//       _fetchNotes();
//     } else {
//       setState(() {
//         username = "Username not found";
//       });
//     }
//   }
//
//   Future<void> _fetchNotes() async {
//     final notes = await dbHelper.getNotes(username);
//     setState(() {
//       _notes = notes;
//     });
//
//     for (var note in _notes) {
//       checkedStates[note.noteId ?? 0] = checkedStates[note.noteId ?? 0] ?? false;
//     }
//     _filterNotes();
//   }
//
//   void _filterNotes() {
//     setState(() {
//       _pendingNotes = _notes.where((note) => !(checkedStates[note.noteId ?? 0] ?? false)).toList();
//       _completedNotes = _notes.where((note) => checkedStates[note.noteId ?? 0] ?? false).toList();
//     });
//   }
//
//   Future<void> _deleteNoteConfirm(int id) async {
//     await dbHelper.deleteNote(id);
//     _fetchNotes();
//   }
//
//   Future<void> _updateNote(int id, String title, String content) async {
//     await dbHelper.updateNote(title, content, id);
//     _fetchNotes();
//   }
//
//   Future<void> logout() async {
//     var sharedPref = await SharedPreferences.getInstance();
//     sharedPref.clear();
//
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginPage()),
//           (Route<dynamic> route) => false,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return false;
//       },
//       child: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: AppBar(
//             title: Text(username),
//             centerTitle: false,
//             actions: [
//               ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   shape: const RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(10)),
//                   ),
//                   backgroundColor: Colors.deepPurple,
//                 ),
//                 onPressed: logout,
//                 label: const Text("Logout"),
//                 icon: const Icon(Icons.logout),
//               ),
//               const Padding(padding: EdgeInsets.symmetric(horizontal: 10))
//             ],
//             bottom: const TabBar(
//               tabs: [
//                 Tab(text: "Pending"),
//                 Tab(text: "Completed"),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: [
//               _buildNoteList(_pendingNotes),
//               _buildNoteList(_completedNotes),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton(
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(50)),
//             ),
//             onPressed: () {
//               Navigator.of(context)
//                   .push(MaterialPageRoute(builder: (context) => const CraeteNote()))
//                   .then((_) {
//                 _fetchNotes();
//               });
//             },
//             child: const Icon(Icons.add),
//           ),
//         ),
//       ),
//     );
//   }
//
// Widget _buildNoteList(List<NoteModel> notes) {
//     return ListView.builder(
//       itemCount: notes.length,
//       itemBuilder: (context, index) {
//         final note = notes[index];
//         final noteId = note.noteId ?? 0;
//
//         bool isChecked = checkedStates[noteId] ?? false;
//
//         return Slidable(
//           key: ValueKey(noteId),
//           direction: Axis.horizontal,
//           endActionPane: ActionPane(
//             motion: const StretchMotion(),
//             extentRatio: 0.25, // Adjust as needed
//             children: [
//               SlidableAction(
//                 onPressed: (context) {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       return AlertDialog(
//                         title: const Text("Delete Note"),
//                         content: Text("Are you sure you want to delete '${note.noteTitle}'?"),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: const Text("Cancel"),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                               _deleteNoteConfirm(noteId);
//                             },
//                             child: const Text("Delete"),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 icon: Icons.delete,
//                 label: 'Delete',
//               ),
//             ],
//           ),
//           child: Card(
//             color: Colors.deepPurple,
//             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: ListTile(
//               leading: Checkbox(
//                 value: isChecked,
//                 onChanged: (bool? value) {
//                   setState(() {
//                     checkedStates[noteId] = value ?? false;
//                   });
//                   _filterNotes();
//                 },
//               ),
//               title: Text(note.noteTitle),
//               subtitle: Text(
//                 note.noteContent,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               onTap: () {
//                 showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       title: Text(note.noteTitle),
//                       content: Text(note.noteContent),
//                       actions: [
//                         TextButton(
//                           onPressed: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: const Text('Close'),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit),
//                 onPressed: () {
//                   showDialog(
//                     context: context,
//                     builder: (context) {
//                       final titleController = TextEditingController(text: note.noteTitle);
//                       final contentController = TextEditingController(text: note.noteContent);
//
//                       return AlertDialog(
//                         title: const Text('Update Note'),
//                         content: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             TextField(
//                               controller: titleController,
//                               decoration: const InputDecoration(labelText: 'Title'),
//                             ),
//                             TextField(
//                               controller: contentController,
//                               decoration: const InputDecoration(labelText: 'Content'),
//                               maxLines: 5,
//                             ),
//                           ],
//                         ),
//                         actions: [
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: const Text('Cancel'),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               _updateNote(
//                                 note.noteId ?? 0,
//                                 titleController.text,
//                                 contentController.text,
//                               );
//                               Navigator.of(context).pop();
//                             },
//                             child: const Text('Save'),
//                           ),
//                         ],
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
//
