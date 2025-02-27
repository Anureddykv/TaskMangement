import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://reqres.in/api";

  // User Authentication
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: jsonEncode({"email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Login failed");
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode({"email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Registration failed");
    }
  }

  // Fetch Users
  Future<List<dynamic>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["data"];
    } else {
      throw Exception("Failed to load users");
    }
  }

  // Task Management API
  static const String taskUrl = "https://jsonplaceholder.typicode.com/todos";

  Future<List<dynamic>> getTasks() async {
    final response = await http.get(Uri.parse(taskUrl));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> taskData) async {
    final response = await http.post(
      Uri.parse(taskUrl),
      body: jsonEncode(taskData),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to create task");
    }
  }

  Future<void> updateTask(int id, Map<String, dynamic> taskData) async {
    final response = await http.put(
      Uri.parse("$taskUrl/$id"),
      body: jsonEncode(taskData),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update task");
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse("$taskUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Failed to delete task");
    }
  }
}
