import 'dart:math';

import 'package:counter/feature/domain/entity/todo_dto.dart';

final _random = Random();

final mockTodos = List.generate(
  10,
  (index) => TodoDto(
    id: index.toString(),
    title: '${actions[_random.nextInt(actions.length)]} ${objects[_random.nextInt(objects.length)]}',
    isCompleted: _random.nextBool(),
  ),
);

const actions = [
  'Do',
  'Make',
  'Take',
  'Create',
  'Build',
  'Write',
  'Read',
  'Learn',
  'Teach',
  'Study',
  'Cook',
  'Eat',
  'Drink',
  'Sleep',
  'Wake',
  'Run',
  'Walk',
  'Jump',
];

const objects = [
  'a book',
  'a cake',
  'a coffee',
  'a tea',
  'a nap',
  'a walk',
  'a run',
  'a song',
  'a dance',
  'a movie',
  'a series',
  'a game',
  'a puzzle',
  'a task',
  'a project',
  'a plan',
  'a goal',
  'a dream',
  'a wish',
];
