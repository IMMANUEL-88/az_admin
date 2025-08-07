import 'dart:convert';
import 'package:http/http.dart' as http;
var present;
var all;
class prsnt {
  List<Map<String, dynamic>> presentUsers = [];
  List<Map<String, dynamic>> absentUsers = [];
  List<Map<String, dynamic>> allUsers = [];

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.14.12:5000/api/v1/attendance/data'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData.containsKey('present_users')) {
        presentUsers = List<Map<String, dynamic>>.from(jsonData['present_users']);
      }

      if (jsonData.containsKey('absent_users')) {
        absentUsers = List<Map<String, dynamic>>.from(jsonData['absent_users']);
        print('Absent: $absentUsers');
      }
      if (jsonData.containsKey('absent_users')) {
        allUsers = List<Map<String, dynamic>>.from(jsonData['all_users']);
        print(allUsers);
        all=allUsers.length;
      }

      // print(presentUsers);
      // print(allUsers);

    } else {
      throw Exception('Failed to load data');
    }
  }
}
