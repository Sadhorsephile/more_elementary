import 'package:counter/feature/domain/entity/todo_dto.dart';
import 'package:counter/feature/presentation/i_example_wm.dart';
import 'package:flutter/material.dart';
import 'package:more_elementary/elementary.dart';
import 'package:union_state/union_state.dart';

class ExampleScreen extends ElementaryWidget<IExampleWM> {
  const ExampleScreen({
    required super.widgetModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wm(context).title),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: _FilterPanel(),
        ),
      ),
      body: const _TodosList(),
    );
  }
}

class _TodosList extends StatelessWidget with WMContext<IExampleWM> {
  const _TodosList();

  @override
  Widget build(BuildContext context) {
    return UnionStateListenableBuilder(
      unionStateListenable: wm(context).todos,
      builder: (context, todos) {
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return _TodoItem(todo: todo);
          },
        );
      },
      loadingBuilder: (_, __) => const Center(child: CircularProgressIndicator()),
      failureBuilder: (_, error, __) => const _ErrorWidget(),
    );
  }
}

class _ErrorWidget extends StatelessWidget with WMContext<IExampleWM> {
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

class _TodoItem extends StatelessWidget with WMContext<IExampleWM> {
  final TodoDto todo;
  const _TodoItem({required this.todo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(todo.title),
      trailing: Checkbox(
        value: todo.isCompleted,
        onChanged: (_) => wm(context).switchCompleted(todo.id),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget with WMContext<IExampleWM> {
  const _FilterPanel();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ValueListenableBuilder(
        valueListenable: wm(context).todos,
        builder: (_, todos, __) => TextField(
          controller: wm(context).filterController,
          enabled: switch (todos) {
            UnionStateFailure() => false,
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
