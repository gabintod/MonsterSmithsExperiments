import 'dart:convert';

import 'package:monster_smiths_experiments/models/Todo/Todo.dart';

class TodoList extends Todo {
  List<Todo> items;

  TodoList(
      {String title,
      String description,
      bool done = true,
      this.items})
      : super(
          title: title,
          description: description,
          done: done,
        );

  bool get isComplete {
    if (items == null) return done = true;

    for (Todo item in items) {
      if (item is TodoList ? !item.isComplete : item.done != true)
        return done = false;
    }

    return done = true;
  }

  TodoList.fromJson(Map<String, dynamic> json)
      : this(
          title: json['title'],
          description: json['description'],
          done: json['done'],
          items: json['items']?.map<Todo>((item) {
            Map<String, dynamic> itemJson = jsonDecode(item);

            if (itemJson['items'] != null)
              return TodoList.fromJson(itemJson);
            return Todo.fromJson(itemJson);
          })?.toList(),
        );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'done': done,
        'items':
            items?.map<String>((item) => jsonEncode(item.toJson()))?.toList(),
      };

  @override
  Todo copyWith({String title, String description, bool done, List<Todo> items}) => TodoList(
    title: title ?? this.title,
    description: description ?? this.description,
    done: done ?? this.done,
    items: items ?? this.items,
  );

  @override
  String toString() {
    return 'TodoList{title: $title, description: $description, done: $done, items: $items}';
  }
}
