import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mangement_project/auth/task_bloc.dart';
import 'package:task_mangement_project/auth/task_event.dart';
import 'package:task_mangement_project/ui/task_form_screen.dart';

class TaskCard extends StatelessWidget {
  final Map<String, dynamic> task;

  TaskCard({required this.task});

  void deleteTask(BuildContext context) {
    BlocProvider.of<TaskBloc>(context).add(DeleteTask(task['id']));
  }

  void editTask(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskFormScreen(task: task)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(task['title']),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => editTask(context),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteTask(context),
            ),
          ],
        ),
      ),
    );
  }
}
