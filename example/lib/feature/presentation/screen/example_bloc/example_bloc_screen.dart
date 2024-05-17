import 'package:counter/feature/domain/bloc/todo_list/todo_list_state.dart';
import 'package:counter/feature/domain/entity/todo_dto.dart';
import 'package:counter/feature/presentation/screen/example_bloc/i_example_bloc_wm.dart';
import 'package:counter/feature/presentation/widgets/some_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_elementary/elementary.dart';

class ExampleBlocScreen extends ElementaryWidget<IExampleBlocWM> {
  const ExampleBlocScreen(
    super.widgetModel, {
    super.key,
  });

  @override
  Widget build(BuildContext context, IExampleBlocWM wm) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wm.title),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: _FilterPanel(),
        ),
      ),
      body: const _TodosList(),
    );
  }
}

class _TodosList extends StatelessWidget with WMContext<IExampleBlocWM> {
  const _TodosList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StateStreamable<TodoListState>, TodoListState>(
      bloc: wm(context).todoData,
      builder: (_, state) => switch (state) {
        LoadingTodoListState() => Center(child: SomeComponent((_) => wm(context).someComponentWM)),
        LoadedTodoListState(:final todos) => ValueListenableBuilder(
            valueListenable: wm(context).processingStatusTodoIds,
            builder: (_, processingIds, __) => ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return _TodoItem(
                  todo: todo,
                  processing: processingIds.contains(todo.id),
                );
              },
            ),
          ),
        ErrorTodoListState() => const _ErrorWidget(),
      },
    );
  }
}

class _ErrorWidget extends StatelessWidget with WMContext<IExampleBlocWM> {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'An error occurred',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => wm(context).loadTodos(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _TodoItem extends StatelessWidget with WMContext<IExampleBlocWM> {
  final TodoDto todo;
  final bool processing;
  const _TodoItem({required this.todo, required this.processing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      trailing: processing
          ? const CircularProgressIndicator()
          : Checkbox(
              value: todo.isCompleted,
              onChanged: (_) => wm(context).switchCompleted(todo.id),
            ),
    );
  }
}

class _FilterPanel extends StatelessWidget with WMContext<IExampleBlocWM> {
  const _FilterPanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BlocBuilder<StateStreamable<TodoListState>, TodoListState>(
        bloc: wm(context).todoData,
        builder: (_, state) => TextField(
          controller: wm(context).filterController,
          enabled: switch (state) {
            ErrorTodoListState() => false,
            _ => true,
          },
          onChanged: (_) => wm(context).onTextChanged(),
          decoration: const InputDecoration(
            labelText: 'Filter',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
