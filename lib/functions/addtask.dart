import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddAnnouncement {
  Future<void> addData(String announcement, String date, String time) async {
    try {
      const String apiUrl = 'http://192.168.14.12:5000/api/v1/announcements';

      // Format date to ensure consistency (YYYY-MM-DD with leading zeros)
      final formattedDate =
          DateFormat('yyyy-MM-dd').format(DateTime.parse(date));

// Format time to ensure consistency (HH:mm:ss with leading zeros)
// First parse the time string into hours and minutes
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
// Create a DateTime object with arbitrary date but correct time
      final dummyDateTime = DateTime(1970, 1, 1, hour, minute);
// Now format it properly
      final formattedTime = DateFormat('HH:mm:ss').format(dummyDateTime);

      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          "message": announcement,
          "date": formattedDate,
          "time": formattedTime,
        },
      );

      if (response.statusCode == 200) {
        print('Announcement added successfully');
      } else {
        print(
            'Failed to add announcement. Server returned status code ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Error adding announcement: $e');
      print('StackTrace: $stackTrace');
      throw Exception('Failed to add announcement: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getPreviousAnnouncements() async {
    try {
      const String apiUrl = 'http://192.168.14.12:5000/api/v1/announcements';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) {
          // Parse and reformat the date to ensure consistency
          DateTime parsedDate;
          try {
            parsedDate = DateTime.parse(item['date']);
          } catch (e) {
            // Fallback for malformed dates - split and reconstruct
            final parts = item['date'].split('-');
            parsedDate = DateTime(
              int.parse(parts[0]),
              int.parse(parts[1]),
              int.parse(parts[2]),
            );
          }

          final formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

          return {
            'message': item['message'],
            'date': formattedDate,
            'time': item['time']?.toString().padLeft(8, '0') ?? '00:00:00',
          };
        }).toList();
      } else {
        throw Exception('Failed to load previous announcements');
      }
    } catch (e) {
      throw Exception('Error fetching previous announcements: $e');
    }
  }
}
