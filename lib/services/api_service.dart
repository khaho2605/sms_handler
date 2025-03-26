import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'YOUR_API_ENDPOINT'; // Replace with your actual endpoint

  static Future<bool> sendMatchedNumbers({
    required String numbers,
    required String phoneNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'numbers': numbers,
          'phoneNumber': phoneNumber,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print('Error sending data to endpoint: $e');
      return false;
    }
  }
}
