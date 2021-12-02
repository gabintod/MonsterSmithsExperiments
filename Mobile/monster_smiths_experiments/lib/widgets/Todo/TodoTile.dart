import 'package:flutter/material.dart';
import 'package:monster_smiths_experiments/models/Todo/Todo.dart';
import 'package:monster_smiths_experiments/widgets/Todo/TodoDialog.dart';

class TodoTile extends StatefulWidget {
  final Todo source;
  final Function(Todo source) onChange;
  final Function(Todo element) onEdit;
  final Function(Todo element) onDelete;

  const TodoTile(
      {Key key,
      @required this.source,
      this.onChange,
      this.onEdit,
      this.onDelete})
      : assert(source != null),
        super(key: key);

  @override
  _TodoTileState createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.surface,
        child: ListTile(
          leading: IconButton(
            icon: Icon(widget.source.done == true
                ? Icons.check_box
                : Icons.check_box_outline_blank),
            onPressed: () {
              _toggleState();
              widget.onChange?.call(widget.source);
            },
          ),
          title: Text(widget.source.title ?? ''),
          subtitle: Text(widget.source.description ?? ''),
          onLongPress: () async {
            Todo edited = await showDialog<Todo>(
              context: context,
              child: TodoDialog(
                source: widget.source,
                onDelete: () => widget.onDelete?.call(widget.source),
              ),
            );

            if (edited != null) widget.onEdit?.call(edited);
          },
        ),
      ),
    );
  }

  void _toggleState() {
    setState(() => widget.source.done = !widget.source.done);
  }
}
