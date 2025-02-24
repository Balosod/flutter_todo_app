import 'package:equatable/equatable.dart';
import 'todo_model.dart';

abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoSuccess extends TodoState {
  final List<Todo> todos;
  TodoSuccess(this.todos);

  @override
  List<Object> get props => [todos];
}

class TodoFailure extends TodoState {
  final String error;
  TodoFailure(this.error);

  @override
  List<Object> get props => [error];
}
