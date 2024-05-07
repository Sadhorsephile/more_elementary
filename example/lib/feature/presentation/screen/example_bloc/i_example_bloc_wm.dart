import 'package:bloc/bloc.dart';
import 'package:counter/feature/domain/bloc/todo_list/todo_list_state.dart';
import 'package:counter/feature/presentation/widgets/some_component_wm.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:more_elementary/elementary.dart';

abstract interface class IExampleBlocWM implements IWidgetModel {
  TextEditingController get filterController;
  String get title;
  StateStreamable<TodoListState> get todoData;
  ISomeComponentWM get someComponentWM;
  ValueListenable<List<String>> get processingStatusTodoIds;

  void switchCompleted(String id);
  void loadTodos();
  void onTextChanged();
}
