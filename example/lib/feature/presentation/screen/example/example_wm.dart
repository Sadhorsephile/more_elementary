import 'package:counter/feature/domain/entity/todo_dto.dart';
import 'package:counter/feature/domain/service/i_todo_service.dart';
import 'package:counter/feature/presentation/screen/example/i_example_wm.dart';
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
  final UnionStateNotifier<List<TodoDto>> todoData = UnionStateNotifier.loading();

  @override
  final filterController = TextEditingController();

  @override
  final WidgetModelFactory<ISomeComponentWM> someComponentWM;

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
    todoData.dispose();
    super.dispose();
  }

  @override
  void onTextChanged() {
    _debouncer.run(loadTodos);
  }

  @override
  Future<void> switchCompleted(String id) async {
    todoData.loading();
    await _todoService.switchCompleted(id);
    loadTodos().ignore();
  }

  @override
  Future<void> loadTodos() async {
    try {
      todoData.loading(todoData.value.data);
      final data = await _todoService.getTodos(filterController.text.trim());
      todoData.content(data);
    } on Exception catch (e) {
      todoData.failure(e, todoData.value.data);
    }
  }
}
