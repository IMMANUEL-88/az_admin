import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/project_model.dart';

List<Map<String, dynamic>> users = [];
var message;
var Users;
List<String> profileBytes = [];
var UsrName;

class Api {
  Future<Map<String, dynamic>> loginAdmin(
      String userId, String password) async {
    try {
      final response = await http.post(
        Uri.parse("http://192.168.14.12:5000/api/v1/auth/loginAdmin"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'userid': userId,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
            'Failed to login: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error during login: $e');
      throw Exception('Failed to login');
    }
  }

  Future<List<Map<String, dynamic>>> fetchData(String userId) async {
    try {
      final response = await http.get(Uri.parse(
          "https://attendzone-backend.onrender.com/api/v1/admin?id=$userId"));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        users = List<Map<String, dynamic>>.from(data);
        //print(users);
        return users;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>?> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse(
          "http://192.168.14.12:5000/api/v1/admin/user"));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        users = List<Map<String, dynamic>>.from(data);
        return users;
      } else {
        // If that response was not OK, throw an error.
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class Verify {
  bool verify(String userId, String password) {
    for (var user in users) {
      if (user["userid"].toString().trim() == userId.trim()) {
        if (user["password"].toString().trim() == password.trim()) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  Future<bool> checkUserIdExists(String userid) async {
    try {
      var url = Uri.parse(
          'https://attendzone-backend.onrender.com/api/v1/user/checkUserExistence');
      var response = await http.post(url, body: {'id': userid});
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var data = json.decode(response.body);
          if (data.containsKey("exists")) {
            bool exists = data["exists"];
            return exists;
          } else {
            print('Invalid response format: missing "exists" field');
            return false;
          }
        } else {
          // Handle empty response body
          print('Empty response body');
          return false;
        }
      } else {
        // Handle HTTP error
        print('Failed to check user ID existence: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle network or server error
      print('Error checking user ID existence: $e');
      return false;
    }
  }
}

class Notion {
Future<List<Project_model>> fetchProjects() async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.14.12:5000/api/v1/chat/projects'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // If backend directly returns an array of projects
      List<dynamic> results = data is List ? data : data['projects'];

      List<Project_model> projects = [];
      for (var json in results) {
        try {
          var project = Project_model.fromJson(json);
          projects.add(project);
        } catch (e) {
          rethrow;
        }
      }
      return projects;
    } else {
      throw Exception('Failed to load projects: ${response.statusCode}');
    }
  } catch (error) {
    rethrow;
  }
}

}
