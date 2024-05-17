import 'package:counter/feature/domain/service/i_todo_service.dart';
import 'package:counter/feature/presentation/screen/example/example_screen.dart';
import 'package:counter/feature/presentation/screen/example/example_wm.dart';
import 'package:counter/feature/presentation/widgets/some_component_wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExampleEntry extends StatelessWidget {
  final String title;

  const ExampleEntry({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ExampleScreen(
      (_) => ExampleWM(
        title: title,
        someComponentWM: (_) => SomeComponentWM(title: '...Loading'),
        todoService: context.read<ITodoService>(),
      ),
    );
  }
}
