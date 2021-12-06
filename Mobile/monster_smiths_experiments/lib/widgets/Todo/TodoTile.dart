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
    return PopupMenuButton(
      child: ListTile(
        leading: GestureDetector(
          child: widget.source.done == true
              ? Icon(Icons.check_box, color: Theme.of(context).colorScheme.primary)
              : Icon(Icons.check_box_outline_blank),
          onTap: () {
            _toggleState();
            widget.onChange?.call(widget.source);
          },
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
              source: widget.source,
            ),
          );

          if (edited != null) widget.onEdit?.call(edited);
        } else if (isDelete == true) {
          bool delete = await showDialog<bool>(
            context: context,
            child: AlertDialog(
              content: Text('Delete ${widget.source.title} ?'),
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
    );
  }

  void _toggleState() {
    setState(() => widget.source.done = !widget.source.done);
  }
}
