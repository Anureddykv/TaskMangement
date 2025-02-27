import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_mangement_project/auth/task_bloc.dart';
import 'package:task_mangement_project/auth/task_event.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:task_mangement_project/repositry/user_repository.dart';

class TaskFormScreen extends StatefulWidget {
  final Map<String, dynamic>? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? dueDate;
  String priority = 'Medium';
  String status = 'To-Do';
  String? assignedUser;
  List<Map<String, dynamic>> users = [];
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!["title"];
      descriptionController.text = widget.task!["description"] ?? "No description";
      dueDate = widget.task!["due_date"] != null ? DateTime.parse(widget.task!["due_date"]) : null;
      priority = widget.task!["priority"] ?? 'Medium';
      status = widget.task!["status"] ?? 'To-Do';
      assignedUser = widget.task!["assigned_user"];
      isCompleted = widget.task!["completed"] ?? false;
    }
    _fetchUsers(); // Fetch users for assignment
  }

  Future<void> _fetchUsers() async {
    List<dynamic> fetchedUsers = await UserRepository().fetchUsers();
    setState(() {
      users = fetchedUsers.cast<Map<String, dynamic>>();
    });
  }


  void _selectDueDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        dueDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? 'Add Task' : 'Edit Task')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Task Title'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text("Due Date: ${dueDate != null ? DateFormat('yyyy-MM-dd').format(dueDate!) : 'Select Date'}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _selectDueDate(context),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: priority,
                decoration: InputDecoration(labelText: 'Priority'),
                items: ['High', 'Medium', 'Low']
                    .map((level) => DropdownMenuItem(value: level, child: Text(level)))
                    .toList(),
                onChanged: (value) => setState(() => priority = value!),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: status,
                decoration: InputDecoration(labelText: 'Status'),
                items: ['To-Do', 'In Progress', 'Done']
                    .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                    .toList(),
                onChanged: (value) => setState(() => status = value!),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: assignedUser,
                decoration: InputDecoration(labelText: 'Assign User'),
                items: users.map((user) {
                  return DropdownMenuItem(
                    value: user["id"].toString(),
                    child: Text(user["first_name"] + " " + user["last_name"]),
                  );
                }).toList(),
                onChanged: (value) => setState(() => assignedUser = value),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Completed"),
                  Switch(
                    value: isCompleted,
                    onChanged: (value) => setState(() => isCompleted = value),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Title and Description are required")),
                    );
                    return;
                  }

                  final taskData = {
                    "title": titleController.text,
                    "description": descriptionController.text,
                    "due_date": dueDate?.toIso8601String(),
                    "priority": priority,
                    "status": status,
                    "assigned_user": assignedUser,
                    "completed": isCompleted,
                  };

                  if (widget.task == null) {
                    context.read<TaskBloc>().add(AddTask(
                      widget.task!["id"] as int,
                      taskData["title"]?.toString() ?? "",
                      taskData["description"]?.toString() ?? "",
                      taskData["due_date"]?.toString() ?? "",
                      taskData["priority"]?.toString() ?? "",
                      taskData["status"]?.toString() ?? "",
                      taskData["assigned_user"]?.toString() ?? "",
                      taskData["completed"] as bool? ?? false,
                    ));
                  } else {
                    context.read<TaskBloc>().add(UpdateTask(
                      widget.task!["id"] as int,
                      taskData["title"]?.toString() ?? "",
                      taskData["description"]?.toString() ?? "",
                      taskData["due_date"]?.toString() ?? "",
                      taskData["priority"]?.toString() ?? "",
                      taskData["status"]?.toString() ?? "",
                      taskData["assigned_user"]?.toString() ?? "",
                      taskData["completed"] as bool? ?? false,
                    ));
                  }
                  Navigator.pop(context);
                },
                child: Text(widget.task == null ? 'Create Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
