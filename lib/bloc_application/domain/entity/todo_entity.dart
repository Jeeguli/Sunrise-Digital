class TodoEntity {
  final String title;
  final String description;
  final bool isCompleted;
  final String category;
  final DateTime createdAt;

  const TodoEntity({
    required this.title,
    required this.description,
    this.isCompleted = false,
    this.category = "Personal",
    required this.createdAt,
  });
}
