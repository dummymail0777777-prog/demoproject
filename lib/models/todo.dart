class Todo {
  final String title;
  bool completed;

  Todo({
    required this.title,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'completed': completed,
      };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        title: json['title'],
        completed: json['completed'],
      );
}