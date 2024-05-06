import 'package:bloc/bloc.dart';
import 'package:counter/feature/domain/bloc/todo_switch/todo_switch_event.dart';
import 'package:counter/feature/domain/bloc/todo_switch/todo_switch_state.dart';
import 'package:counter/feature/domain/service/i_todo_service.dart';

class TodoSwitchBloc extends Bloc<TodoSwitchEvent, TodoSwitchState> {
  final ITodoService todoService;
  TodoSwitchBloc(this.todoService) : super(InitialTodoSwitchState()) {
    on<SwitchTodoEvent>(_onSwitchTodoSwitchEvent);
  }

  Future<void> _onSwitchTodoSwitchEvent(SwitchTodoEvent event, Emitter<TodoSwitchState> emit) async {
    try {
      emit(LoadingTodoSwitchState(event.id));
      await todoService.switchCompleted(event.id);
      emit(LoadedTodoSwitchState(event.id));
    } on Object catch (e) {
      emit(ErrorTodoSwitchState(event.id, e.toString()));
    }
  }
}
