import 'package:flutter/foundation.dart';
import '../models/task.dart';
import 'package:uuid/uuid.dart';
import '../services/storage_service.dart'; // import storage

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    _loadTasks(); // load saved tasks when provider starts
  }

  Future<void> _loadTasks() async {
    _tasks = await StorageService.loadTasks();
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    await StorageService.saveTasks(_tasks);
  }

  void addTask(String title, String description, DateTime date) {
    final newTask = Task(
      id: const Uuid().v4(),
      title: title,
      description: description,
      date: date,
    );
    _tasks.add(newTask);
    _saveTasks(); // save after adding
    notifyListeners();
  }

  void updateTask(String id, String title, String description, DateTime date) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex].title = title;
      _tasks[taskIndex].description = description;
      _tasks[taskIndex].date = date;
      _saveTasks(); // save after updating
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks(); // save after deleting
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final taskIndex = _tasks.indexWhere((task) => task.id == id);
    if (taskIndex != -1) {
      _tasks[taskIndex].isCompleted = !_tasks[taskIndex].isCompleted;
      _saveTasks(); // save after toggling
      notifyListeners();
    }
  }
}