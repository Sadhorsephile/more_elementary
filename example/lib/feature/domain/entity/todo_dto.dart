import 'package:flutter/foundation.dart';

@immutable
class TodoDto {
  final String id;
  final String title;
  final bool isCompleted;

  const TodoDto({
    required this.id,
    required this.title,
    required this.isCompleted,
  });

  TodoDto copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return TodoDto(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
