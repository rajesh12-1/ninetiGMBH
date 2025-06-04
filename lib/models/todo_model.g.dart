// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Todo _$TodoFromJson(Map<String, dynamic> json) => Todo(
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  todo: json['todo'] as String,
  completed: json['completed'] as bool,
);

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'todo': instance.todo,
  'completed': instance.completed,
};
