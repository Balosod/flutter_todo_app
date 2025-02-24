import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';
import 'todo_model.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  TodoBloc() : super(TodoInitial()) {
    on<AddTodos>(_onAddTodo);
    on<ToggleTodo>(_onToggleTodo);
    on<EditTodo>(_onEditTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  List<Todo> _todos = [];

  Future<void> _onAddTodo(AddTodos event, Emitter<TodoState> emit) async {
    emit(TodoLoading());

    try {
      if (event.title.isNotEmpty) {
        final newTodo = Todo(
          id: _todos.length + 1,
          title: event.title,
        );
        _todos = [..._todos, newTodo];

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
