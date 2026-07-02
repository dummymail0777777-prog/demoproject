import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/todo_provider.dart';
import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Checkbox(
            value: todo.completed,
            onChanged: (value) {
              Provider.of<TodoProvider>(context, listen: false).toggleTodo(
                Provider.of<TodoProvider>(context, listen: false).todos.indexOf(todo),
              );
            },
            activeColor: Colors.blueAccent,
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              decoration: todo.completed ? TextDecoration.lineThrough : TextDecoration.none,
              color: todo.completed ? Colors.grey : null,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  final result = await showDialog<String?> (
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Edit Todo'),
                      content: TextField(
                        autofocus: true,
                        controller: TextEditingController(text: todo.title),
                        onSubmitted: (value) => Navigator.pop(context, value),
                        decoration: const InputDecoration(
                          hintText: 'Edit todo item',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            final field = context.findRenderObject() as RenderBox;
                            final value = (field.findAncestorStateOfType<TextFieldState>()?.controller?.text);
                            Navigator.pop(context, value);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                  );
                  
                  if (result != null && result.trim().isNotEmpty) {
                    Provider.of<TodoProvider>(context, listen: false).editTodo(
                      Provider.of<TodoProvider>(context, listen: false).todos.indexOf(todo),
                      result,
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Provider.of<TodoProvider>(context, listen: false).deleteTodo(
                    Provider.of<TodoProvider>(context, listen: false).todos.indexOf(todo),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}