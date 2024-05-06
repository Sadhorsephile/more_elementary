sealed class TodoListEvent {}

class LoadTodoListEvent extends TodoListEvent {
  final String filter;

  LoadTodoListEvent(this.filter);
}
