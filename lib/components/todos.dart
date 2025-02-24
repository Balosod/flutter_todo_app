import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/bloc.dart';
import 'bloc/state.dart';
import 'bloc/event.dart';
import 'bloc/todo_model.dart';

class Todos extends StatelessWidget {
  const Todos({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
      if (state is TodoLoading) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is TodoSuccess) {
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return _buildMobileList(state.todos, context);
              } else {
                return _buildResponsiveTable(state.todos, context);
              }
            },
          ),
        );
      }
      ;
      return const Center(child: Text("No Todos Found"));
    });
  }

  Widget _buildMobileList(List<Todo> todos, BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Checkbox(
              value: todo.completed,
              onChanged: (_) => context.read<TodoBloc>().add(ToggleTodo(todo)),
            ),
            title: Text(todo.title),
            // subtitle: Text("ID: #${todo.id}"),
            trailing: PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) => _handleTodoAction(value, todo, context),
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveTable(List<Todo> todos, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align heading to the top-left
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Todo List", // Add heading
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Align(
            alignment: Alignment.center, // Center the table
            child: Container(
              constraints: const BoxConstraints(
                minWidth: 600,
                maxWidth: 1200,
              ),
              margin: const EdgeInsets.all(16),
              child: DataTable(
                columnSpacing: 20,
                horizontalMargin: 12,
                columns: const [
                  // DataColumn(label: Text("ID")),
                  DataColumn(label: Text("Title")),
                  DataColumn(label: Text("Status")),
                  DataColumn(label: Text("Action")),
                ],
                rows: todos
                    .map((todo) => DataRow(
                          cells: [
                            // DataCell(Text("#${todo.id}")),
                            DataCell(ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: Text(todo.title),
                            )),
                            DataCell(Checkbox(
                              value: todo.completed,
                              onChanged: (_) => context
                                  .read<TodoBloc>()
                                  .add(ToggleTodo(todo)),
                            )),
                            DataCell(
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, size: 20),
                                onSelected: (value) =>
                                    _handleTodoAction(value, todo, context),
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                      value: 'edit', child: Text('Edit')),
                                  const PopupMenuItem(
                                      value: 'delete', child: Text('Delete')),
                                ],
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTodoAction(String action, Todo todo, BuildContext context) async {
    if (action == 'edit') {
      final editedTodo = await showDialog<Todo>(
        context: context,
        builder: (context) => EditTodoDialog(todo: todo),
      );

      if (editedTodo != null) {
        context.read<TodoBloc>().add(EditTodo(editedTodo));
      }
    } else if (action == 'delete') {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete Todo?'),
          content: Text('Are you sure you want to delete "${todo.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );

      if (confirm == true) {
        context.read<TodoBloc>().add(DeleteTodo(todo.id));
      }
    }
  }
}

class EditTodoDialog extends StatefulWidget {
  final Todo todo;
  const EditTodoDialog({super.key, required this.todo});

  @override
  State<EditTodoDialog> createState() => _EditTodoDialogState();
}

class _EditTodoDialogState extends State<EditTodoDialog> {
  late TextEditingController _titleController;
  late bool _completed;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    _completed = widget.todo.completed;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Todo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Status:'),
              const SizedBox(width: 16),
              Switch(
                value: _completed,
                onChanged: (value) => setState(() => _completed = value),
              ),
              Text(_completed ? 'Completed' : 'Pending'),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
              Todo(
                id: widget.todo.id,
                title: _titleController.text,
                completed: _completed,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
