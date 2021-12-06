import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monster_smiths_experiments/models/Todo/Todo.dart';
import 'package:monster_smiths_experiments/models/Todo/TodoList.dart';
import 'package:monster_smiths_experiments/widgets/Todo/TodoDialog.dart';
import 'package:monster_smiths_experiments/widgets/Todo/TodoListTile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoPage extends StatefulWidget {
  static const String todo_lists_memkey = 'todo_lists';

  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<TodoList> lists;

  @override
  void initState() {
    _fetchLists().then((memLists) => setState(() => lists = memLists));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Icon(
                    Icons.check,
                    color: Colors.green,
                    size: Theme
                        .of(context)
                        .textTheme
                        .headline2
                        .fontSize,
                  ),
                  Text(
                    'Todo',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline2,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: lists?.length ?? 0,
                itemBuilder: (context, index) => TodoListTile(
                  source: lists[index],
                  onChange: (_) => _save().then((_) => print('saved')),
                  onAdd: _onAdd,
                  onEdit: (todo) => _onEdit(null, index, todo),
                  onEditItem: _onEdit,
                  onDelete: (todo) => _onDelete(null, todo),
                  onDeleteItem: _onDelete,
                  primary: true,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          Todo added = await showDialog<Todo>(
              context: context,
              child: TodoDialog(
                  isList: true, canChangeType: false));

          if (added != null) _onAdd(null, added);
        },
      ),
    );
  }

  Future<bool> _save() async {
    return (await SharedPreferences.getInstance()).setStringList(
        TodoPage.todo_lists_memkey,
        lists.map<String>((item) => jsonEncode(item.toJson())).toList());
  }

  Future<List<TodoList>> _fetchLists() async {
    return ((await SharedPreferences.getInstance())
        .getStringList(TodoPage.todo_lists_memkey) ?? [])
        .map<TodoList>((list) => TodoList.fromJson(jsonDecode(list)))
        .toList();
  }

  void _onAdd(TodoList parent, Todo element) {
    setState(() {
      if (parent != null) {
        if (parent.items != null)
          parent.items.add(element);
        else
          parent.items = [element];
      } else
        lists.add(element);

      _refreshDoneValues();
    });

    _save().then((_) => print('added and saved'));
  }

  void _onEdit(TodoList parent, int index, Todo element) {
    print('_onEdit($parent, $index, $element)');
    print('Change ${(parent?.items ?? lists)[index]} to $element');

    setState(() {
      if (parent != null)
        parent.items[index] = element;
      else
        lists[index] = element;

      _refreshDoneValues();
    });

    _save().then((_) => print('edited and saved'));
  }

  void _onDelete(TodoList parent, Todo element) {
    setState(() {
      if (parent != null)
        parent.items.remove(element);
      else
        lists.remove(element);

      _refreshDoneValues();
    });

    _save().then((_) => print('removed and saved'));
  }

  void _refreshDoneValues() {
    lists?.forEach((list) => list.isComplete);
  }
}
