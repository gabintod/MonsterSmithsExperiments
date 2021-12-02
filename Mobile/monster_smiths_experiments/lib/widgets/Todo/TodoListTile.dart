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

  const TodoListTile(
      {Key key,
      @required this.source,
      this.expanded,
      this.onChange,
      this.onAdd,
      this.onEdit,
      this.onEditItem,
      this.onDelete,
      this.onDeleteItem})
      : assert(source != null),
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
        elevation: 10,
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            ListTile(
              leading: Icon(widget.source.done
                  ? Icons.check_box
                  : Icons.check_box_outline_blank),
              trailing: Icon(expanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down),
              title: Text(widget.source.title),
              onTap: () => setState(() => expanded = !expanded),
              onLongPress: () async {
                Todo edited = await showDialog<Todo>(
                  context: context,
                  child: TodoDialog(
                    source: widget.source,
                    onDelete: () => widget.onDelete?.call(widget.source),
                  ),
                );

                if (edited != null)
                  setState(() {
                    widget.onEdit?.call(edited);
                  });
              },
            ),
            Expandable(
              expanded: expanded,
              alignment: Alignment.bottomCenter,
              child: Material(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Container(
                  padding: EdgeInsets.only(top: 3),
                  alignment: Alignment.center,
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: (widget.source.items?.length ?? 0) + 1,
                    itemBuilder: (context, index) {
                      if (index >= (widget.source.items?.length ?? 0))
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Opacity(
                            opacity: 0.5,
                            child: ListTile(
                              dense: true,
                              title: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 5,
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .color,
                                  ),
                                  Text(
                                    'Add item',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .color),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                Todo added = await showDialog<Todo>(
                                    context: context, child: TodoDialog());

                                if (added != null)
                                  widget.onAdd?.call(widget.source, added);
                              },
                            ),
                          ),
                        );

                      Todo item = widget.source.items[index];

                      if (item is TodoList)
                        return TodoListTile(
                          source: item,
                          onChange: (_) => _change(widget.source.isComplete),
                          onAdd: widget.onAdd,
                          onEdit: (todo) => widget.onEditItem
                              ?.call(widget.source, index, todo),
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
