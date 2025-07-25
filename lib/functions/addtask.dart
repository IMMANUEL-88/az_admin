import 'dart:convert';
import 'package:http/http.dart' as http;

class add_Announcement {
  Future<void> addData(String announcement, String date, String time) async {

    try {
      const String apiUrl = 'https://attendzone-backend.onrender.com/api/v1/announcements';
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "message" : announcement,
          "date"    : date,
          "time"    : time,

        },
      );
      if (response.statusCode == 200) {
        print('Task added successfully');
      } else {
        print('Failed to add task. Server returned status code ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error adding task: $e');
      print('StackTrace: $stackTrace');
    }
  }

  Future<List<Map<String, dynamic>>> getPreviousAnnouncements() async {
    try {
      const String apiUrl = 'https://attendzone-backend.onrender.com/api/v1/announcements';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(response.body);
        return data.map((item) => {
          'message': item['message'],
          'date': item['date'],
          'time': item['time']
        }).toList();

      } else {
        throw Exception('Failed to load previous announcements');
      }
    } catch (e) {
      throw Exception('Error fetching previous announcements: $e');
    }
  }
}
