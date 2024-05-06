sealed class TodoSwitchEvent {}

class SwitchTodoEvent extends TodoSwitchEvent {
  final String id;

  SwitchTodoEvent(this.id);
}