import 'package:bloc_sunrise/bloc_application/domain/entity/todo_entity.dart';

abstract class TodoRepository {
  Future<List<TodoEntity>> getTodos();
  Future<void> saveTodos(List<TodoEntity> todos);
}
