import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  TodoProvider() {
    loadTodos();  // Ensure to handle errors during loading.
  }

  void addTodo(Todo todo) {
    _todos.add(todo);
    saveTodos();
    notifyListeners();
  }

  void editTodo(Todo todo) {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      saveTodos();
      notifyListeners();
    }
  }

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    saveTodos();
    notifyListeners();
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosJson = _todos.map((todo) => todo.toJson()).toList();
    await prefs.setString('todos', jsonEncode(todosJson));
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedData = prefs.getString('todos');
    if (encodedData != null) {
      final List<dynamic> decodedData = jsonDecode(encodedData);
      _todos = decodedData.map((item) => Todo.fromJson(item)).toList();
      notifyListeners();
    }
  }
}