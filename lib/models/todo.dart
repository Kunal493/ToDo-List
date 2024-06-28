import 'package:flutter/foundation.dart';

class Todo {
  final String id;
  final String name;
  final String? description;
  final DateTime? remindingTime;
  final int? priority;

  Todo({
    required this.id,
    required this.name,
    this.description,
    this.remindingTime,
    this.priority,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      remindingTime: json['remindingTime'] != null ? DateTime.parse(
          json['remindingTime']) : null,
      priority: json['priority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'remindingTime': remindingTime?.toIso8601String(),
      'priority': priority,
    };
  }
}
