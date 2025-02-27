import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime dueDate;

  @HiveField(4)
  final String priority;

  @HiveField(5)
  final String status;

  @HiveField(6)
  final int assignedUserId;

  @HiveField(7)
  final bool? completed;

  TaskModel({
     this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.status,
    required this.assignedUserId,
     this.completed,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "Untitled",
      description: json["description"] ?? "No description",
      dueDate: DateTime.parse(json["dueDate"]),
      priority: json["priority"],
      status: json["status"],
      assignedUserId: json["assignedUserId"],
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "dueDate": dueDate.toIso8601String(),
      "priority": priority,
      "status": status,
      "assignedUserId": assignedUserId,
      'completed': completed,
    };
  }
}
