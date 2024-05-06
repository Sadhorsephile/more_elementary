import 'package:bloc/bloc.dart';
import 'package:counter/feature/domain/bloc/todo_list/todo_list_event.dart';
import 'package:counter/feature/domain/bloc/todo_list/todo_list_state.dart';
import 'package:counter/feature/domain/service/i_todo_service.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  final ITodoService todoService;
  TodoListBloc(this.todoService) : super(LoadingTodoListState()) {
    on<LoadTodoListEvent>(_onLoadTodoListEvent);
  }

  Future<void> _onLoadTodoListEvent(LoadTodoListEvent event, Emitter<TodoListState> emit) async {
    try {
      emit(LoadingTodoListState());
      final todos = await todoService.getTodos(event.filter);
      emit(LoadedTodoListState(todos));
    } on Object catch (e) {
      emit(ErrorTodoListState(e.toString()));
    }
  }
}
