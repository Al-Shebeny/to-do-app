import 'package:get/get.dart';
import 'package:to/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  final List taskList = <Task>[].obs;
  Future<int> addTask({Task? task}) {
    return DBHelper.insert(task);
  }

  getTasks() async {
    final List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  deletTasks(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  deletAllTasks() async {
    await DBHelper.deleteAll();
    getTasks();
  }

  markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
