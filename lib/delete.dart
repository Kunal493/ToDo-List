import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/todo_provider.dart';
import 'models/todo.dart';

class DeleteTodoScreen extends StatelessWidget {
  final Todo todo;

  DeleteTodoScreen({required this.todo});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Delete Todo'),
      content: Text('Are you sure you want to delete this todo?'),
      actions: [
        TextButton(
          onPressed: () {
            Provider.of<TodoProvider>(context, listen: false).deleteTodo(todo.id);
            Navigator.of(context).pop();
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('No'),
        ),
      ],
    );
  }
}

