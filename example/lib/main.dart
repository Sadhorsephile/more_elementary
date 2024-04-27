import 'package:counter/feature/domain/i_todo_service.dart';
import 'package:counter/feature/domain/todo_service.dart';
import 'package:counter/feature/presentation/example_entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider<ITodoService>(
        create: (_) => TodoService(),
        child: const ExampleEntry(title: 'TODOs'),
      ),
    );
  }
}
