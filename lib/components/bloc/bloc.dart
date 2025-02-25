import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'event.dart';
import 'state.dart';
import 'todo_model.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<AddTodos>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<EditTodo>(_onEditTodo);
    on<DeleteTodo>(_onDeleteTodo);

    _loadTodos(); // Load saved todos on initialization
  }

  List<Todo> _todos = [];

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todosJson = prefs.getString('todos');

    if (todosJson != null) {
      final List<dynamic> todosList = jsonDecode(todosJson);
      _todos = todosList.map((todo) => Todo.fromJson(todo)).toList();
      emit(TodoSuccess(_todos)); // Emit saved state
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String todosJson = jsonEncode(_todos.map((t) => t.toJson()).toList());
    await prefs.setString('todos', todosJson);
  }

  Future<void> _onAddTodo(AddTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    try {
      if (event.title.isNotEmpty) {
        final newTodo = Todo(
          id: _todos.length + 1,
          title: event.title,
        );
        _todos = [..._todos, newTodo];
        await _saveTodos();
        emit(TodoSuccess(_todos)); // Emit new state
      } else {
        emit(TodoFailure("Failed to Add Todo"));
      }
    } catch (e) {
      emit(TodoFailure("Something went wrong"));
    }
  }

  void _onToggleTodo(ToggleTodo event, Emitter<TodoState> emit) {
    emit(TodoLoading());

    _todos = _todos.map((t) {
      if (t.id == event.todo.id) {
        return t.copyWith(completed: !t.completed);
      }
      return t;
    }).toList();

    emit(TodoSuccess(_todos));
  }

  void _onEditTodo(EditTodo event, Emitter<TodoState> emit) {
    emit(TodoLoading());

    _todos = _todos.map((t) {
      return t.id == event.updatedTodo.id ? event.updatedTodo : t;
    }).toList();

    emit(TodoSuccess(_todos));
  }

  void _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) {
    emit(TodoLoading());

    _todos = _todos.where((t) => t.id != event.todoId).toList();

    emit(TodoSuccess(_todos));
  }
}
