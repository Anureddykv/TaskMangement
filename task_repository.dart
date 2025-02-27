import 'dart:convert';
import 'package:http/http.dart' as http;

class TaskRepository {
  final String baseUrl = "https://jsonplaceholder.typicode.com/todos";

  Future<List<Map<String, dynamic>>> getTasks() async {
    final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos"));

    print("API Response Code: ${response.statusCode}");
    print("API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((task) => {
        "id": task["id"] ?? "N/A",
        "title": task["title"] ?? "No Title",
        "completed": task["completed"] ?? false
      }).toList();
    } else {
      throw Exception("Failed to fetch tasks. Status Code: ${response.statusCode}");
    }
  }


  Future<Map<String, dynamic>> createTask(String title) async {
    final response = await http.post(
      Uri.parse("https://jsonplaceholder.typicode.com/todos"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "completed": false}),
    );

    if (response.statusCode == 201) {
      final newTask = jsonDecode(response.body);
      return {
        "id": newTask["id"] ?? DateTime.now().millisecondsSinceEpoch,
        "title": newTask["title"],
        "completed": newTask["completed"]
      };
    } else {
      throw Exception("Failed to create task");
    }
  }


  Future<Map<String, dynamic>> updateTask(int id, String title, bool completed) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "completed": completed}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to update task");
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete task");
    }
  }
}
