import 'package:counter/feature/domain/bloc/todo_list/todo_list_bloc.dart';
import 'package:counter/feature/domain/bloc/todo_switch/todo_switch_bloc.dart';
import 'package:counter/feature/domain/service/i_todo_service.dart';
import 'package:counter/feature/presentation/screen/example_bloc/example_bloc_screen.dart';
import 'package:counter/feature/presentation/screen/example_bloc/example_bloc_wm.dart';
import 'package:counter/feature/presentation/widgets/some_component_wm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExampleBlocEntry extends StatelessWidget {
  final String title;

  const ExampleBlocEntry({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final service = context.read<ITodoService>();
    return ExampleBlocScreen(
      ExampleBlocWM(
        title: title,
        someComponentWM: SomeComponentWM(title: '...Loading'),
        todoData: TodoListBloc(service),
        todoSwitchBloc: TodoSwitchBloc(service),
      ),
    );
  }
}
