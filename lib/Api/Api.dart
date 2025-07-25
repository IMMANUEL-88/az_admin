import 'dart:convert';
import '../models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ApiService {
  final String _baseUrl = "http://localhost:5000/api/v2";

  // Fetches a complete user document, including the embedded array of their posts.
  Future<User> fetchUser(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/users/$userId'));

    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("User data fetched successfully: ${response.body}");
      }
      return User.fromJson(json.decode(response.body));
    } else {
      if (kDebugMode) {
        print("Failed to load user. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
      throw Exception('Failed to load user');
    }
  }

  // Adds a new post directly to a user's embedded `posts` array.
  Future<void> createPostForUser(String userId, String content) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/users/$userId/posts'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'content': content,
      }),
    );

    if (response.statusCode != 201) {
      if (kDebugMode) {
        print(
            "Failed to create post. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
      throw Exception('Failed to create post.');
    } else {
      if (kDebugMode) {
        print("Post created successfully.");
      }
    }
  }
}
