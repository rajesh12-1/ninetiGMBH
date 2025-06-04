// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://dummyjson.com';

  Future<Map<String, dynamic>> fetchUsers(int limit, int skip, [String? query]) async {
    String url = '$baseUrl/users?limit=$limit&skip=$skip';
    if (query != null && query.isNotEmpty) {
      url = '$baseUrl/users/search?q=$query&limit=$limit&skip=$skip';
    }
    final response = await http.get(Uri.parse(url));
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> fetchUserPosts(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/user/$userId'));
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> fetchUserTodos(int userId) async {
    final response = await http.get(Uri.parse('$baseUrl/todos/user/$userId'));
    return jsonDecode(response.body);
  }
}
