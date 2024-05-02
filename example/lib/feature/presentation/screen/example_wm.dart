import 'dart:developer';

import 'package:counter/feature/domain/entity/todo_dto.dart';
import 'package:counter/feature/domain/i_todo_service.dart';
import 'package:counter/feature/presentation/screen/i_example_wm.dart';
import 'package:counter/feature/presentation/widgets/some_component_wm.dart';
import 'package:counter/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:more_elementary/elementary.dart';
import 'package:union_state/union_state.dart';

class ExampleWM extends LiteWidgetModel implements IExampleWM {
  @override
  final String title;

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  final ITodoService _todoService;

  @override
  final UnionStateNotifier<List<TodoDto>> todos = UnionStateNotifier.loading();

  @override
  final filterController = TextEditingController();

  @override
  final ISomeComponentWM someComponentWM;

  ExampleWM({
    required this.title,
    required this.someComponentWM,
    required ITodoService todoService,
  }) : _todoService = todoService;

  @override
  void initWidgetModel() {
    super.initWidgetModel();
    loadTodos();
  }

  @override
  void dispose() {
    filterController.dispose();
    todos.dispose();
    super.dispose();
  }

  @override
  void onTextChanged() {
    _debouncer.run(loadTodos);
  }

  @override
  Future<void> switchCompleted(String id) async {
    return handleCall(
      operation: () {
        todos.loading();
        return _todoService.switchCompleted(id);
      },
      onSuccess: (_) => loadTodos(),
      onError: (_, __) {
        todos.failure();
      },
      displayableError: true,
    );
  }

  @override
  void logError(Object error, StackTrace? stackTrace, {required bool displayableError}) {
    log('Error: $error', stackTrace: stackTrace, error: error);

    if (displayableError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  @override
  Future<void> loadTodos() async {
    await handleCall(
      displayableError: true,
      operation: () async {
        todos.loading(todos.value.data);
        return _todoService.getTodos(filterController.text.trim());
      },
      onError: (e, _) {
        todos.failure();
      },
      onSuccess: todos.content,
    );
  }
}
