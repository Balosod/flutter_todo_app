import 'package:equatable/equatable.dart';
import 'todo_model.dart';

abstract class TodoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddTodos extends TodoEvent {
  final String title;
  AddTodos(this.title);

  @override
  List<Object> get props => [title];
}

// Toggle completion state of a TODO
class ToggleTodo extends TodoEvent {
  final Todo todo;

  ToggleTodo(this.todo);

  @override
  List<Object> get props => [todo];
}

// Edit a TODO
class EditTodo extends TodoEvent {
  final Todo updatedTodo;

  EditTodo(this.updatedTodo);

  @override
  List<Object> get props => [updatedTodo];
}

// Delete a TODO
class DeleteTodo extends TodoEvent {
  final int todoId;

  DeleteTodo(this.todoId);

  @override
  List<Object> get props => [todoId];
}


class SearchTodos extends TodoEvent {
  final String query;
  SearchTodos(this.query);

   @override
  List<Object> get props => [query];
}

class ReloadTodos extends TodoEvent {
  @override
  List<Object> get props => [];
}
