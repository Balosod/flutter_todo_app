class Todo {
  final int id;
  final String title;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    this.completed = false,
  });

  // Add copyWith for immutability
  Todo copyWith({String? title, bool? completed}) {
    return Todo(
      id: id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
