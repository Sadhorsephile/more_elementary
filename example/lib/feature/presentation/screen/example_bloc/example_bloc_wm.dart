import 'dart:async';

import 'package:counter/feature/domain/bloc/todo_list/todo_list_bloc.dart';
import 'package:counter/feature/domain/bloc/todo_list/todo_list_event.dart';
import 'package:counter/feature/domain/bloc/todo_switch/todo_switch_bloc.dart';
import 'package:counter/feature/domain/bloc/todo_switch/todo_switch_event.dart';
import 'package:counter/feature/domain/bloc/todo_switch/todo_switch_state.dart';

import 'package:counter/feature/presentation/screen/example_bloc/i_example_bloc_wm.dart';
import 'package:counter/feature/presentation/widgets/some_component_wm.dart';
import 'package:counter/utils/debouncer.dart';
import 'package:counter/utils/list_value_notifier.dart';
import 'package:flutter/material.dart';
import 'package:more_elementary/elementary.dart';

class ExampleBlocWM extends LiteWidgetModel implements IExampleBlocWM {
  @override
  final String title;

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  @override
  final TodoListBloc todoData;

  @override
  final ListValueNotifier<String> processingStatusTodoIds = ListValueNotifier([]);

  @override
  final filterController = TextEditingController();

  @override
  final ISomeComponentWM someComponentWM;

  final TodoSwitchBloc _todoSwitchBloc;

  late final StreamSubscription<TodoSwitchState> _todoSwitchBlocSubscription;

  ExampleBlocWM({
    required this.title,
    required this.someComponentWM,
    required this.todoData,
    required TodoSwitchBloc todoSwitchBloc,
  }) : _todoSwitchBloc = todoSwitchBloc;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _todoSwitchBlocSubscription = _todoSwitchBloc.stream.listen(_onTodoSwitchStateChanged);
    loadTodos();
  }

  void _onTodoSwitchStateChanged(TodoSwitchState state) {
    switch (state) {
      case InitialTodoSwitchState():
        break;
      case LoadingTodoSwitchState(:final id):
        processingStatusTodoIds.value = processingStatusTodoIds.value..add(id);
        break;
      case LoadedTodoSwitchState(:final id):
        processingStatusTodoIds.value = processingStatusTodoIds.value..remove(id);
        loadTodos();
        break;
      case ErrorTodoSwitchState(:final message, :final id):
        processingStatusTodoIds.value = processingStatusTodoIds.value..remove(id);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
        break;
    }
  }

  @override
  void dispose() {
    filterController.dispose();
    _todoSwitchBlocSubscription.cancel();
    super.dispose();
  }

  @override
  void onTextChanged() {
    _debouncer.run(loadTodos);
  }

  @override
  Future<void> switchCompleted(String id) async {
    _todoSwitchBloc.add(SwitchTodoEvent(id));
  }

  @override
  Future<void> loadTodos() async {
    todoData.add(LoadTodoListEvent(filterController.text));
  }
}
