import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthRepository {
  final String baseUrl = "https://reqres.in/api";

  Future<String> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://reqres.in/api/login'),
      body: jsonEncode({"email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );

    print("Login Request: Email: $email, Password: $password");
    print("Login Response Code: ${response.statusCode}");
    print("Login Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["token"];
    } else {
      throw Exception("Login failed: ${response.body}");
    }
  }



  Future<void> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: jsonEncode({"email": email, "password": password}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Registration failed.");
    }
  }
}
