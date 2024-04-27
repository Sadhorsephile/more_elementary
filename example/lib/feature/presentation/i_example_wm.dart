import 'package:counter/feature/domain/entity/todo_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:more_elementary/elementary.dart';
import 'package:union_state/union_state.dart';

abstract interface class IExampleWM implements IWidgetModel {
  TextEditingController get filterController;
  String get title;
  ValueListenable<UnionState<List<TodoDto>>> get todos;
  

  void switchCompleted(String id);
  void loadTodos();
  void onTextChanged();
}
