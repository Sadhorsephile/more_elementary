import 'package:counter/feature/domain/i_todo_service.dart';
import 'package:counter/feature/presentation/screen/example_screen.dart';
import 'package:counter/feature/presentation/screen/example_wm.dart';
import 'package:counter/feature/presentation/widgets/some_component_wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExampleEntry extends StatelessWidget {
  final String title;

  const ExampleEntry({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ExampleScreen(
      ExampleWM(
        title: title,
        someComponentWM: SomeComponentWM(title: '...Loading'),
        todoService: context.read<ITodoService>(),
      ),
    );
  }
}
