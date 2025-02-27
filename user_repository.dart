import 'package:dio/dio.dart';

class UserRepository {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await _dio.get("https://reqres.in/api/users");
      return response.data["data"];
    } catch (e) {
      throw Exception("Failed to load users");
    }
  }

  Future<Map<String, dynamic>> fetchUserById(int id) async {
    try {
      final response = await _dio.get("https://reqres.in/api/users/$id");
      return response.data["data"];
    } catch (e) {
      throw Exception("Failed to load user");
    }
  }
}
