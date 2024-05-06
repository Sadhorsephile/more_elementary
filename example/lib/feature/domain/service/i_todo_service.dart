import 'package:counter/feature/domain/entity/todo_dto.dart';

abstract interface class ITodoService {
  Future<List<TodoDto>> getTodos(String filter);

  Future<void> switchCompleted(String id);
}