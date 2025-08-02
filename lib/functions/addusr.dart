import 'package:http/http.dart' as http;
import 'dart:convert';

class AddUser {
  Future<void> addData({
  required String userId,  // Changed from int to String to match backend
  required String username,
  required String password,
  required String ip,
  required String email,
  String phone = "",      // Added optional phone field
  String image = "",      // Changed parameter name to be more descriptive
}) async {
  try {
    const String apiUrl = 'http://192.168.14.12:5000/api/v1/users';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "userid": userId,  // Matches backend expectation
        "username": username,
        "password": password,  // Will be stored as password_hash in backend
        "ip": ip,
        "profile": image,
        "email": email,
        "phone": phone,    // Added phone field
      }),
    );

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print('User added successfully. User ID: ${responseData['userId']}');
    } else {
      print('Failed to add user. Status: ${response.statusCode}');
      print('Error: ${responseData['error'] ?? 'Unknown error'}');
      if (responseData.containsKey('details')) {
        print('Details: ${responseData['details']}');
      }
      throw Exception('Failed to add user: ${responseData['error'] ?? 'Unknown error'}');
    }
  } catch (e, stackTrace) {
    print('Error adding user: $e');
    print('StackTrace: $stackTrace');
    rethrow;  // Rethrow to allow calling code to handle the error
  }
}
}
