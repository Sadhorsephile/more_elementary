import 'package:counter/feature/domain/entity/todo_dto.dart';
import 'package:counter/feature/presentation/screen/example/i_example_wm.dart';
import 'package:counter/feature/presentation/widgets/some_component.dart';
import 'package:flutter/material.dart';
import 'package:more_elementary/elementary.dart';
import 'package:union_state/union_state.dart';

class ExampleScreen extends ElementaryWidget<IExampleWM> {
  const ExampleScreen(
    super.widgetModelFactory, {
    super.key,
  });

  @override
  Widget build(BuildContext context, IExampleWM wm) {
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

class _TodosList extends StatelessWidget with WMStless<IExampleWM> {
  const _TodosList();

  @override
  Widget buildWithWm(BuildContext context, IExampleWM wm) {
    return UnionStateListenableBuilder(
      unionStateListenable: wm.todoData,
      builder: (context, todos) {
        return ListView.builder(
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return _TodoItem(todo: todo);
          },
        );
      },
      loadingBuilder: (_, __) => Center(child: SomeComponent(wm.someComponentWM)),
      failureBuilder: (_, error, __) => const _ErrorWidget(),
    );
  }
}

class _ErrorWidget extends StatelessWidget with WMStless<IExampleWM> {
  const _ErrorWidget();

  @override
  Widget buildWithWm(BuildContext context, IExampleWM wm) {
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
            onPressed: () => wm.loadTodos(),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}

class _TodoItem extends StatelessWidget with WMStless<IExampleWM> {
  final TodoDto todo;
  const _TodoItem({required this.todo});

  @override
  Widget buildWithWm(BuildContext context, IExampleWM wm) {
    return ListTile(
      title: Text(todo.title),
      trailing: Checkbox(
        value: todo.isCompleted,
        onChanged: (_) => wm.switchCompleted(todo.id),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget with WMStless<IExampleWM> {
  const _FilterPanel();

  @override
  Widget buildWithWm(BuildContext context, IExampleWM wm) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: ValueListenableBuilder(
        valueListenable: wm.todoData,
        builder: (_, todos, __) => TextField(
          controller: wm.filterController,
          enabled: switch (todos) {
            UnionStateFailure() => false,
            _ => true,
          },
          onChanged: (_) => wm.onTextChanged(),
          decoration: const InputDecoration(
            labelText: 'Filter',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
