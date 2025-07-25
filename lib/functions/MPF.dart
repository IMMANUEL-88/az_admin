import 'package:http/http.dart' as http;

class MPF {
  bool _isUpdated = false; // Flag to track if update has been done

  Future<void> updateTO(String userId, var date, var timeout, var timein) async {
    if (!_isUpdated) { // Check if update has already been done
      // Format the date to a string that matches the expected format in your PHP

      var url = Uri.parse("https://attendzone-backend.onrender.com/api/v1/attendance/admin/mark");
      var response = await http.post(url, body: {
        'id': userId, // Ensure 'userId' is sent as a String
        'date': date,
        'time_out': timeout,
        'time_in': timein,
      });

      if (response.statusCode == 200) {
        print('Time updated successfully');
        _isUpdated = true; // Set flag to indicate update has been done
      } else {
        print('Failed to update Time: ${response.body}');
      }
    } else {
      print('Data already updated, skipping...');
    }
  }
}
