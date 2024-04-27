import 'package:counter/feature/domain/entity/todo_dto.dart';
import 'package:counter/feature/domain/i_todo_service.dart';
import 'package:counter/feature/presentation/i_example_wm.dart';
import 'package:counter/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:more_elementary/elementary.dart';
import 'package:union_state/union_state.dart';

class ExampleWM extends WidgetModel implements IExampleWM {
  @override
  final String title;

  final _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

  final ITodoService _todoService;

  @override
  final UnionStateNotifier<List<TodoDto>> todos = UnionStateNotifier.loading();

  @override
  final filterController = TextEditingController();

  ExampleWM({
    required this.title,
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
    todos.loading();
    await _todoService.switchCompleted(id);
    loadTodos().ignore();
  }

  @override
  Future<void> loadTodos() async {
    try {
      todos.loading(todos.value.data);
      final data = await _todoService.getTodos(filterController.text.trim());
      todos.content(data);
    } on Exception catch (e) {
      todos.failure(e, todos.value.data);
    }
  }
}
