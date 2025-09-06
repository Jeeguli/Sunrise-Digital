import 'package:bloc_sunrise/bloc_application/data/model/todo_bloc_model.dart';
import 'package:bloc_sunrise/bloc_application/data/repository/todo_repository.dart';
import 'package:bloc_sunrise/bloc_application/domain/entity/todo_entity.dart';
import 'package:bloc_sunrise/bloc_application/presentation/cubit/todo_bloc_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository repository;

  TodoCubit(this.repository) : super(const TodoState()) {
    loadTodos();
  }

  Future<void> addTodo(
    String title,
    String desc, {
    String category = "Personal",
  }) async {
    final newTodo = TodoBlocModel(
      title: title,
      description: desc,
      category: category,
      createdAt: DateTime.now(),
    );
    final updatedTodos = List<TodoEntity>.from(state.todos)..add(newTodo);
    emit(state.copyWith(todos: updatedTodos));
    await repository.saveTodos(updatedTodos);
  }

  Future<void> toggleTodo(int index) async {
    final updatedTodos = List<TodoEntity>.from(state.todos);
    final oldTodo = updatedTodos[index] as TodoBlocModel;
    updatedTodos[index] = TodoBlocModel(
      title: oldTodo.title,
      description: oldTodo.description,
      isCompleted: !oldTodo.isCompleted,
      category: oldTodo.category,
      createdAt: oldTodo.createdAt,
    );
    emit(state.copyWith(todos: updatedTodos));
    await repository.saveTodos(updatedTodos);
  }

  Future<void> deleteTodo(int index) async {
    final updatedTodos = List<TodoEntity>.from(state.todos)..removeAt(index);
    emit(state.copyWith(todos: updatedTodos));
    await repository.saveTodos(updatedTodos);
  }

  Future<void> loadTodos() async {
    final todos = await repository.getTodos();
    emit(state.copyWith(todos: todos));
  }
}
