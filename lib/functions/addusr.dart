import 'package:http/http.dart' as http;
import 'dart:convert';

class AddUser {
  Future<void> addData(String userid, String username, String password, String ip, String email, String image) async {
    try {
      const String apiUrl = 'https://attendzone-backend.onrender.com/api/v1/users';
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json', // Set the Content-Type header to JSON
        },
        body: jsonEncode({
          "userid": userid,
          "username": username,
          "password": password,
          "ip": ip,
          "profile": image,
          "email": email,
        }),
      );

      if (response.statusCode == 200) {
        print('User added successfully');
      } else {
        print('Failed to add user. Server returned status code ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error adding user: $e');
      print('StackTrace: $stackTrace');
    }
  }
}
