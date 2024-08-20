class NoteModel {
  final int? noteId; // Nullable
  final String noteTitle;
  final String noteContent;
  final String createdAt;
  bool isCompleted; // New field to track completion status


  NoteModel({
    this.noteId, // noteId can be null
    required this.noteTitle,
    required this.noteContent,
    required this.createdAt,
    this.isCompleted = false,

  });

  // Convert a NoteModel object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'noteId': noteId, // Nullable in the map
      'noteTitle': noteTitle,
      'noteContent': noteContent,
      'createdAt': createdAt,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  // Extract a NoteModel object from a Map object
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      noteId: map['noteId'] as int?,
      noteTitle: map['noteTitle'] as String,
      noteContent: map['noteContent'] as String,
      createdAt: map['createdAt'] as String,
      isCompleted: map['isCompleted'] == 1,
    );
  }
}



// class NoteModel {
//   final int? noteId; // Nullable
//   final String noteTitle;
//   final String noteContent;
//   final String createdAt;
//   bool isCompleted; // Field to track completion status
//
//   NoteModel({
//     this.noteId, // noteId can be null
//     required this.noteTitle,
//     required this.noteContent,
//     required this.createdAt,
//     this.isCompleted = false,
//   });
//
//   // Convert a NoteModel object into a Map object
//   Map<String, dynamic> toMap() {
//     return {
//       'noteId': noteId,
//       'noteTitle': noteTitle,
//       'noteContent': noteContent,
//       'createdAt': createdAt,
//       'isCompleted': isCompleted ? 1 : 0,
//     };
//   }
//
//   // Extract a NoteModel object from a Map object
//   factory NoteModel.fromMap(Map<String, dynamic> map) {
//     return NoteModel(
//       noteId: map['noteId'] as int?,
//       noteTitle: map['noteTitle'] as String,
//       noteContent: map['noteContent'] as String,
//       createdAt: map['createdAt'] as String,
//       isCompleted: map['isCompleted'] == 1,
//     );
//   }
// }