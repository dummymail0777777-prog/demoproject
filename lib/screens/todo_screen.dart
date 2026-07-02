import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/todo_provider.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          final activeTodos = provider.activeTodos;
          final completedTodos = provider.completedTodos;

          return ListView(
            children: [
              // Active Todos
              if (activeTodos.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Active Todos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ...activeTodos.map((todo) => TodoItem(todo: todo)).toList(),
                  ],
                ),
              
              // Completed Todos
              if (completedTodos.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      child: Text(
                        'Completed Todos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ...completedTodos.map((todo) => TodoItem(todo: todo)).toList(),
                  ],
                ),
              
              // Empty state
              if (activeTodos.isEmpty && completedTodos.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'No todos yet. Add one to get started!',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<String?> (
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add New Todo'),
              content: TextField(
                autofocus: true,
                onSubmitted: (value) => Navigator.pop(context, value),
                decoration: const InputDecoration(
                  hintText: 'Enter a todo item',
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
                  child: const Text('Add'),
                ),
              ],
            ),
          );
          
          if (result != null && result.trim().isNotEmpty) {
            Provider.of<TodoProvider>(context, listen: false).addTodo(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}