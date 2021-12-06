import 'package:flutter/material.dart';
import 'package:monster_smiths_experiments/models/Todo/Todo.dart';
import 'package:monster_smiths_experiments/models/Todo/TodoList.dart';
import 'package:monster_smiths_experiments/widgets/Todo/TodoDialog.dart';
import 'package:monster_smiths_experiments/widgets/Todo/TodoTile.dart';
import 'package:monster_smiths_experiments/widgets/utils/Expandable.dart';

class TodoListTile extends StatefulWidget {
  final TodoList source;
  final bool expanded;
  final Function(bool isDone) onChange;
  final Function(TodoList parent, Todo element) onAdd;
  final Function(Todo element) onEdit;
  final Function(TodoList parent, int index, Todo element) onEditItem;
  final Function(Todo element) onDelete;
  final Function(TodoList parent, Todo element) onDeleteItem;
  final bool primary;

  const TodoListTile({
    Key key,
    @required this.source,
    this.expanded,
    this.onChange,
    this.onAdd,
    this.onEdit,
    this.onEditItem,
    this.onDelete,
    this.onDeleteItem,
    this.primary = false,
  })  : assert(source != null),
        super(key: key);

  @override
  _TodoListTileState createState() => _TodoListTileState();
}

class _TodoListTileState extends State<TodoListTile> {
  bool expanded;

  @override
  void initState() {
    expanded = widget.expanded == true;
    widget.source.isComplete;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Material(
        clipBehavior: Clip.hardEdge,
        elevation: 7,
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          children: [
            PopupMenuButton(
              child: ListTile(
                leading: widget.source.done == true
                    ? Icon(Icons.check_box,
                        color: Theme.of(context).colorScheme.primary)
                    : Icon(Icons.check_box_outline_blank),
                trailing: GestureDetector(
                  onTap: () => setState(() => expanded = !expanded),
                  child: Icon(expanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down),
                ),
                title: Text(widget.source.title ?? ''),
                subtitle: widget.source.description != null &&
                        widget.source.description.trim().isNotEmpty
                    ? Text(widget.source.description)
                    : null,
              ),
              itemBuilder: (context) => [
                PopupMenuItem<bool>(
                  value: false,
                  child: Text('Edit'),
                ),
                PopupMenuItem<bool>(
                  value: true,
                  child: Text('Delete'),
                ),
              ],
              onSelected: (isDelete) async {
                if (isDelete == false) {
                  Todo edited = await showDialog<Todo>(
                    context: context,
                    child: TodoDialog(
                      canChangeType: !widget.primary,
                      source: widget.source,
                    ),
                  );

                  if (edited != null) widget.onEdit?.call(edited);
                } else if (isDelete == true) {
                  bool delete = await showDialog<bool>(
                      context: context,
                      child: AlertDialog(
                        content: Text(
                            'You are deleting a non empty List. All its items will be lost.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Continue'),
                          ),
                        ],
                      ),
                    );

                    if (delete != true)
                      return;

                  delete = await showDialog<bool>(
                    context: context,
                    child: AlertDialog(
                      content: Text(
                          'Delete ${widget.source.title} ?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('No'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Yes'),
                        ),
                      ],
                    ),
                  );

                  if (delete == true) widget.onDelete?.call(widget.source);
                }
              },
              offset: Offset(1, 1),
            ),
            Expandable(
              expanded: expanded,
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: (widget.source.items?.length ?? 0) + 1,
                  itemBuilder: (context, index) {
                    if (index >= (widget.source.items?.length ?? 0))
                      return TextButton(
                        onPressed: () async {
                          Todo added = await showDialog<Todo>(
                              context: context, child: TodoDialog());

                          if (added != null)
                            widget.onAdd?.call(widget.source, added);
                        },
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 5,
                          children: [
                            Icon(Icons.add),
                            Text('Add item'),
                          ],
                        ),
                      );

                    Todo item = widget.source.items[index];

                    if (item is TodoList)
                      return TodoListTile(
                        source: item,
                        onChange: (_) => _change(widget.source.isComplete),
                        onAdd: widget.onAdd,
                        onEdit: (todo) =>
                            widget.onEditItem?.call(widget.source, index, todo),
                        onEditItem: widget.onEditItem,
                        onDelete: (todo) =>
                            widget.onDeleteItem?.call(widget.source, todo),
                        onDeleteItem: widget.onDeleteItem,
                      );
                    return TodoTile(
                      source: item,
                      onChange: (_) => _change(widget.source.isComplete),
                      onEdit: (todo) =>
                          widget.onEditItem?.call(widget.source, index, todo),
                      onDelete: (todo) =>
                          widget.onDeleteItem?.call(widget.source, todo),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _change(bool isDone) {
    setState(() => isDone);
    widget.onChange?.call(isDone);
  }
}
