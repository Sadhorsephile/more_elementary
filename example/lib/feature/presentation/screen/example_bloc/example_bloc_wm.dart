import 'dart:async';

import 'package:counter/feature/domain/bloc/todo_list/todo_list_bloc.dart';
import 'package:counter/feature/domain/bloc/todo_list/todo_list_event.dart';
import 'package:counter/feature/domain/bloc/todo_list/todo_list_state.dart';
import 'package:counter/feature/domain/bloc/todo_switch/todo_switch_bloc.dart';
import 'package:counter/feature/domain/bloc/todo_switch/todo_switch_event.dart';
import 'package:counter/feature/domain/bloc/todo_switch/todo_switch_state.dart';
import 'package:counter/feature/domain/entity/todo_dto.dart';

import 'package:counter/feature/presentation/screen/example_bloc/i_example_bloc_wm.dart';
import 'package:counter/feature/presentation/widgets/some_component_wm.dart';
import 'package:counter/utils/debouncer.dart';
import 'package:counter/utils/list_value_notifier.dart';
import 'package:flutter/material.dart';
import 'package:more_elementary/elementary.dart';
import 'package:union_state/union_state.dart';

class ExampleBlocWM extends LiteWidgetModel implements IExampleBlocWM {
  @override
  final String title;

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  @override
  final UnionStateNotifier<List<TodoDto>> todoData = UnionStateNotifier.loading();

  @override
  final ListValueNotifier<String> processingStatusTodoIds = ListValueNotifier([]);

  @override
  final filterController = TextEditingController();

  @override
  final ISomeComponentWM someComponentWM;

  final TodoListBloc _todoListBloc;

  final TodoSwitchBloc _todoSwitchBloc;

  late final StreamSubscription<TodoListState> _todoListBlocSubscription;
  late final StreamSubscription<TodoSwitchState> _todoSwitchBlocSubscription;

  ExampleBlocWM({
    required this.title,
    required this.someComponentWM,
    required TodoListBloc todoListBloc,
    required TodoSwitchBloc todoSwitchBloc,
  })  : _todoListBloc = todoListBloc,
        _todoSwitchBloc = todoSwitchBloc;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    _todoListBlocSubscription = _todoListBloc.stream.listen(_onTodoListStateChanged);
    _todoSwitchBlocSubscription = _todoSwitchBloc.stream.listen(_onTodoSwitchStateChanged);
    loadTodos();
  }

  void _onTodoListStateChanged(TodoListState state) {
    switch (state) {
      case LoadingTodoListState():
        todoData.loading(todoData.value.data);
        break;
      case LoadedTodoListState(:final todos):
        todoData.content(todos);
        break;
      case ErrorTodoListState(:final message):
        todoData.failure(Exception(message), todoData.value.data);
        break;
    }
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
    todoData.dispose();
    _todoListBlocSubscription.cancel();
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
    _todoListBloc.add(LoadTodoListEvent(filterController.text));
  }
}
