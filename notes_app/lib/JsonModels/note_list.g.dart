// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteList _$NoteListFromJson(Map<String, dynamic> json) => NoteList(
      (json['id'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      json['title'] as String?,
      json['noteContent'] as String?,
      json['completed'] as bool,
    );

Map<String, dynamic> _$NoteListToJson(NoteList instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'noteContent': instance.noteContent,
      'completed': instance.completed,
    };
