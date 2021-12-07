import 'package:flutter/material.dart';
import 'package:monster_smiths_experiments/models/Todo/Todo.dart';
import 'package:monster_smiths_experiments/models/Todo/TodoList.dart';

class TodoDialog extends StatefulWidget {
  final Todo source;
  final bool canChangeType;
  final bool isList;

  const TodoDialog(
      {Key key,
      this.source,
      this.canChangeType = true,
      this.isList})
      : super(key: key);

  @override
  _TodoDialogState createState() => _TodoDialogState();
}

class _TodoDialogState extends State<TodoDialog> {
  GlobalKey<FormState> _formKey = GlobalKey();
  String _title;
  String _description;
  bool _isList;

  @override
  void initState() {
    if (widget.isList != null)
      _isList = widget.isList;
    else
      _isList = widget.source != null && widget.source is TodoList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(
          '${widget.source != null ? 'Edit' : 'Add'} ${_isList ? 'a List' : 'a Todo'}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.canChangeType == true)
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                children: [
                  ChoiceChip(
                    label: Text('Todo'),
                    selected: !_isList,
                    onSelected: (_) => setState(() => _isList = false),
                  ),
                  ChoiceChip(
                    label: Text('List'),
                    selected: _isList,
                    onSelected: (_) => setState(() => _isList = true),
                  ),
                ],
              ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: widget.source?.title,
              decoration: InputDecoration(
                labelText: 'Title',
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty)
                  return 'Title must be filled';
                return null;
              },
              onSaved: (value) => _title = value.trim(),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: widget.source?.description,
              decoration: InputDecoration(
                labelText: 'Description',
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onSaved: (value) => _description = value.trim(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: _confirm,
          child: Text(widget.source != null ? 'Edit' : 'Add'),
        ),
      ],
    );
  }

  Future<void> _confirm() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (widget.source != null &&
          widget.source is TodoList &&
          (widget.source as TodoList).items != null &&
          (widget.source as TodoList).items.isNotEmpty) {
        // is not empty list
        if (_isList)
          Navigator.pop(
            context,
            TodoList(
              title: _title,
              description: _description,
              items: (widget.source as TodoList).items,
            ),
          );
        else {
          bool confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(
                  'You are changing a not empty List into a Todo. You will lose all its items.'),
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

          if (confirm == true)
            Navigator.pop(
              context,
              Todo(title: _title, description: _description, done: widget.source?.done ?? false),
            );
        }
      } else {
        if (_isList)
          Navigator.pop(
            context,
            TodoList(title: _title, description: _description),
          );
        else
          Navigator.pop(
            context,
            Todo(title: _title, description: _description, done: widget.source?.done ?? false),
          );
      }
    }
  }
}
