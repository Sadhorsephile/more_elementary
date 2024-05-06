import 'package:counter/feature/domain/entity/todo_dto.dart';
import 'package:counter/feature/domain/mock_todos.dart';
import 'package:counter/feature/domain/service/i_todo_service.dart';

class TodoService implements ITodoService {
  final _pseudoNetworkTodos = mockTodos;

  @override
  Future<List<TodoDto>> getTodos(String filter) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    return _pseudoNetworkTodos.where((todo) => todo.title.toLowerCase().contains(filter.toLowerCase())).toList();
  }

  @override
  Future<void> switchCompleted(String id) async {
    await Future<void>.delayed(const Duration(seconds: 1));

    final index = _pseudoNetworkTodos.indexWhere((todo) => todo.id == id);
    if (index == -1) return;

    final todo = _pseudoNetworkTodos[index];
    final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
    _pseudoNetworkTodos[index] = updatedTodo;
  }
}
