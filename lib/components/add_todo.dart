import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/bloc.dart';
import 'bloc/state.dart';
import 'bloc/event.dart';

class AddTodo extends StatefulWidget {
  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisSize:
                    MainAxisSize.min, // Ensures content is centered vertically
                mainAxisAlignment:
                    MainAxisAlignment.center, // Center align the children
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Align children in the center horizontally
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Todo Title',
                      border: OutlineInputBorder(),
                      hintText: 'Enter your todo item',
                    ),
                    autofocus: true,
                    onSubmitted: (_) {
                      final todoText = _controller.text.trim();
                      if (todoText.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Todo cannot be empty!")),
                        );
                        return;
                      }
                      context
                          .read<TodoBloc>()
                          .add(AddTodos(_controller.text.trim()));
                      // context.go("/todos");
                      Future.delayed(Duration(milliseconds: 300), () {
                        context.go("/todos");
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final todoText = _controller.text.trim();
                      if (todoText.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Todo cannot be empty!")),
                        );
                        return;
                      }
                      context
                          .read<TodoBloc>()
                          .add(AddTodos(_controller.text.trim()));
                      // context.go("/todos");
                      Future.delayed(Duration(milliseconds: 300), () {
                        context.go("/todos");
                      });
                    },
                    child: const Text('Add Todo'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
