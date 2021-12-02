class Todo {
  String title;
  String description;
  bool done;

  Todo({this.title, this.description, this.done = false});

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        done = json['done'];

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'done': done,
      };

  Todo copyWith({String title, String description, bool done}) => Todo(
    title: title ?? this.title,
    description: description ?? this.description,
    done: done ?? this.done,
  );

  @override
  String toString() {
    return 'Todo{title: $title, description: $description, done: $done}';
  }
}
