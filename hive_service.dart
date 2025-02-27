import 'package:hive/hive.dart';
import 'package:task_mangement_project/model/task_model.dart';

class HiveService {
  static const String taskBoxName = "tasks";

  Future<void> init() async {
    await Hive.openBox<TaskModel>(taskBoxName);
  }

  Future<void> saveTask(TaskModel task) async {
    final box = Hive.box<TaskModel>(taskBoxName);
    await box.put(task.id, task);
  }

  List<TaskModel> getTasks() {
    final box = Hive.box<TaskModel>(taskBoxName);
    return box.values.toList();
  }
  Future<void> deleteTask(int id) async {
    final box = Hive.box<TaskModel>(taskBoxName);
    await box.delete(id);
  }
}
