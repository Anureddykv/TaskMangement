import 'package:equatable/equatable.dart';
import 'package:task_mangement_project/model/task_model.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String status;
  final String assignedUser;
  final bool completed;

  AddTask( this.id,
      this.title,
      this.description,
      this.dueDate,
      this.priority,
      this.status,
      this.assignedUser,
      this.completed,
      );

  @override
  List<Object?> get props => [id, title, description, dueDate, priority, status, assignedUser, completed
  ];
}

class UpdateTask extends TaskEvent {
  final int id;
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final String status;
  final String assignedUser;
  final bool completed;

  UpdateTask(
      this.id,
      this.title,
      this.description,
      this.dueDate,
      this.priority,
      this.status,
      this.assignedUser,
      this.completed,
      );

  @override
  List<Object?> get props => [
    id, title, description, dueDate, priority, status, assignedUser, completed
  ];
}

class CreateTask extends TaskEvent {
  final TaskModel task;
  CreateTask(this.task);
}

class DeleteTask extends TaskEvent {
  final int id;

  DeleteTask(this.id);

  @override
  List<Object?> get props => [id];
}
