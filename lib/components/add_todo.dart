import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddTodo extends StatefulWidget {
  final Function(String) onAdd;
  const AddTodo({super.key, required this.onAdd});

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
          child: Center(
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
                  onSubmitted: (_) => _saveTodo(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveTodo,
                  child: const Text('Add Todo'),
                ),
              ],
            ),
          )),
    );
  }

  void _saveTodo() {
    if (_controller.text.isNotEmpty) {
      widget.onAdd(_controller.text);
      // context.pop(); // Use go_router to go back
      context.go("/todos");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
