import 'package:equatable/equatable.dart';
import 'package:bloc_sunrise/bloc_application/domain/entity/todo_entity.dart';

class TodoState extends Equatable {
  final List<TodoEntity> todos;

  const TodoState({this.todos = const []});

  TodoState copyWith({List<TodoEntity>? todos}) {
    return TodoState(todos: todos ?? this.todos);
  }

  @override
  List<Object?> get props => [todos];
}
