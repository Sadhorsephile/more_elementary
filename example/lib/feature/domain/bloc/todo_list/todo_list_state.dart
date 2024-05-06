import 'package:counter/feature/domain/entity/todo_dto.dart';

sealed class TodoListState {}

class LoadingTodoListState extends TodoListState {}

class LoadedTodoListState extends TodoListState {
  final List<TodoDto> todos;

  LoadedTodoListState(this.todos);
}

class ErrorTodoListState extends TodoListState {
  final String message;

  ErrorTodoListState(this.message);
}
