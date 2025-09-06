import 'dart:convert';

import 'package:bloc_sunrise/bloc_application/data/model/todo_bloc_model.dart';
import 'package:bloc_sunrise/bloc_application/data/repository/todo_repository.dart';
import 'package:bloc_sunrise/bloc_application/domain/entity/todo_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoRepositoryImpl implements TodoRepository {
  final SharedPreferences prefs;

  TodoRepositoryImpl(this.prefs);

  @override
  Future<List<TodoEntity>> getTodos() async {
    final data = prefs.getStringList("todoListVal");
    if (data == null) return [];
    return data.map((e) => TodoBlocModel.fromJson(jsonDecode(e))).toList();
  }

  @override
  Future<void> saveTodos(List<TodoEntity> todos) async {
    final data = todos.map((e) {
      if (e is TodoBlocModel) {
        return jsonEncode(e.toJson());
      }
      throw Exception("Expected TodoBlocModel but got ${e.runtimeType}");
    }).toList();
    await prefs.setStringList("todoListVal", data);
  }
}
