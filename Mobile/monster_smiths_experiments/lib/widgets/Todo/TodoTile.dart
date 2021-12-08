import 'package:flutter/material.dart';
import 'package:monster_smiths_experiments/models/Todo/Todo.dart';
import 'package:monster_smiths_experiments/widgets/Todo/TodoDialog.dart';

class TodoTile extends StatefulWidget {
  final int index;
  final Todo source;
  final Function(Todo source) onChange;
  final Function(Todo element) onEdit;
  final Function(Todo element) onDelete;

  const TodoTile(
      {Key key,
      @required this.source,
      @required this.index,
      this.onChange,
      this.onEdit,
      this.onDelete})
      : assert(source != null),
        super(key: key);

  @override
  _TodoTileState createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  Offset _tapPosition;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ListTile(
        leading: widget.source.done == true
            ? Icon(Icons.check_box,
            color: Theme.of(context).colorScheme.primary)
            : Icon(Icons.check_box_outline_blank),
        title: Text(widget.source.title ?? ''),
        subtitle: widget.source.description != null &&
            widget.source.description.trim().isNotEmpty
            ? Text(widget.source.description)
            : null,
        trailing: ReorderableDragStartListener(
            index: widget.index,
            child: Icon(Icons.drag_handle),
        ),
        onTap: () {
          _toggleState();
          widget.onChange?.call(widget.source);
        },
        onLongPress: () async {
          bool isDelete = await showMenu<bool>(
            context: context,
            position: RelativeRect.fromRect(
              _tapPosition & const Size(40, 40),
              Offset.zero & (Overlay.of(context).context.findRenderObject() as RenderBox).size,
            ),
            items: [
              PopupMenuItem<bool>(
                value: false,
                child: Text('Edit'),
              ),
              PopupMenuItem<bool>(
                value: true,
                child: Text('Delete'),
              ),
            ],
          );

          if (isDelete == false) {
            Todo edited = await showDialog<Todo>(
              context: context,
              builder: (context) => TodoDialog(
                source: widget.source,
              ),
            );

            if (edited != null) widget.onEdit?.call(edited);
          } else if (isDelete == true) {
            bool delete = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
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
      ),
      onTapDown: (details) => _tapPosition = details.globalPosition,
    );
  }

  void _toggleState() {
    setState(() => widget.source.done = !widget.source.done);
  }
}
