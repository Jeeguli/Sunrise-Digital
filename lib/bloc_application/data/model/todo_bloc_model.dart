import 'package:bloc_sunrise/bloc_application/domain/entity/todo_entity.dart';

class TodoBlocModel extends TodoEntity {
  const TodoBlocModel({
    required super.title,
    required super.description,
    super.isCompleted = false,
    super.category = "Personal",
    required super.createdAt,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "isCompleted": isCompleted,
    "category": category,
    "createdAt": createdAt.toIso8601String(),
  };

  factory TodoBlocModel.fromJson(Map<String, dynamic> json) => TodoBlocModel(
    title: json["title"],
    description: json["description"],
    isCompleted: json["isCompleted"] ?? false,
    category: json["category"] ?? "Personal",
    createdAt: DateTime.parse(
      json["createdAt"] ?? DateTime.now().toIso8601String(),
    ),
  );
}
