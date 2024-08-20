import 'package:json_annotation/json_annotation.dart';

part 'note_list.g.dart';

@JsonSerializable()
class NoteList{
  // @JsonKey(name: 'userId')
  final int? id;
  final int? userId; // Nullable
  final String? title;
  final String? noteContent;
  bool completed=false;

  NoteList(this.id ,this.userId, this.title, this.noteContent,
      this.completed);

  factory NoteList.fromJson(Map<String, dynamic> json) => _$NoteListFromJson(json);

  /// Connect the generated [_$PersonToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$NoteListToJson(this);
}
