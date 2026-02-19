import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _tasksKey = 'tasks';

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => json.encode({
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'date': task.date.toIso8601String(),
      'isCompleted': task.isCompleted,
    })).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey) ?? [];
    return tasksJson.map((taskJson) {
      final Map<String, dynamic> taskMap = json.decode(taskJson);
      return Task(
        id: taskMap['id'],
        title: taskMap['title'],
        description: taskMap['description'],
        date: DateTime.parse(taskMap['date']),
        isCompleted: taskMap['isCompleted'],
      );
    }).toList();
  }
}