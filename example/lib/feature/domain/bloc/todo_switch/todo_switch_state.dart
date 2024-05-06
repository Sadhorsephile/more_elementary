sealed class TodoSwitchState {}

class InitialTodoSwitchState extends TodoSwitchState {}

class LoadingTodoSwitchState extends TodoSwitchState {
  final String id;

  LoadingTodoSwitchState(this.id);
}

class LoadedTodoSwitchState extends TodoSwitchState {
  final String id;

  LoadedTodoSwitchState(this.id);
}

class ErrorTodoSwitchState extends TodoSwitchState {
  final String id;
  final String message;

  ErrorTodoSwitchState(this.id, this.message);
}
