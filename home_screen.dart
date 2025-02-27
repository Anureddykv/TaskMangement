import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mangement_project/auth/task_bloc.dart';
import 'package:task_mangement_project/auth/task_event.dart';
import 'package:task_mangement_project/auth/task_state.dart';
import 'package:task_mangement_project/ui/users_list_screen.dart';
import 'task_form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      BlocProvider.of<TaskBloc>(context).add(LoadTasks());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UsersListScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskError) {
            return Center(
                child:
                    Text(state.message, style: TextStyle(color: Colors.red)));
          } else if (state is TaskLoaded) {
            if (state.tasks.isEmpty) {
              return Center(child: Text("No tasks available"));
            }
            return ListView.builder(
              itemCount: state.tasks.length,
              itemBuilder: (context, index) {
                final task = state.tasks[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(task["title"] ?? "No Title",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description: ${task["description"] ?? "No Description"}"),
                        Text("Due Date: ${task["due_date"] ?? "No Due Date"}"),
                        Text("Priority: ${task["priority"] ?? "Not Set"}"),
                        Text("Status: ${task["status"] ?? "To-Do"}"),
                        Text("Assigned User: ${task["assigned_user"] ?? "Unassigned"}"),
                        Text(
                          "Completed: ${task["completed"] == true ? "Yes" : "No"}",
                          style: TextStyle(
                            color: task["completed"] == true ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () async {
                            final updatedTask = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskFormScreen(task: task),
                              ),
                            );

                            if (updatedTask != null) {
                              BlocProvider.of<TaskBloc>(context).add(
                                UpdateTask(
                                   task["id"] as int,
                                  updatedTask["title"]?.toString() ?? "",
                                   updatedTask["description"]?.toString() ?? "",
                                  updatedTask["due_date"]?.toString() ?? "",
                                   updatedTask["priority"]?.toString() ?? "",
                                 updatedTask["status"]?.toString() ?? "",
                                  updatedTask["assigned_user"]?.toString() ?? "",
                                  updatedTask["completed"] as bool? ?? false,
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            BlocProvider.of<TaskBloc>(context)
                                .add(DeleteTask(task["id"]));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

          }
          return Center(child: Text("Unexpected State"));
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskFormScreen()),
          );
          if (result != null && result == true) {
            BlocProvider.of<TaskBloc>(context)
                .add(LoadTasks());
          }
        },
      ),
    );
  }
}
