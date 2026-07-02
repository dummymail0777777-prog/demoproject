import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoProvider() {
    loadTodos();
  }

  void addTodo(String title) {
    if (title.trim().isNotEmpty) {
      _todos.add(Todo(title: title, completed: false));
      saveTodos();
      notifyListeners();
    }
  }

  void toggleTodo(int index) {
    _todos[index].completed = !_todos[index].completed;
    saveTodos();
    notifyListeners();
  }

  void editTodo(int index, String title) {
    if (title.trim().isNotEmpty) {
      _todos[index].title = title;
      saveTodos();
      notifyListeners();
    }
  }

  void deleteTodo(int index) {
    _todos.removeAt(index);
    saveTodos();
    notifyListeners();
  }

  List<Todo> get activeTodos => _todos.where((todo) => !todo.completed).toList();

  List<Todo> get completedTodos => _todos.where((todo) => todo.completed).toList();

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = prefs.getString('todos') ?? '[]';
    final List<dynamic> decoded = jsonDecode(todosJson);
    _todos = decoded.map((item) => Todo.fromJson(item)).toList();
    notifyListeners();
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('todos', jsonEncode(_todos.map((todo) => todo.toJson()).toList()));
  }
}