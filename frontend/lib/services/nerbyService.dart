// filepath: c:\Users\HP\Desktop\intagrate project\ai-health-assistant-app\frontend\lib\services\nerbyService.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class nearbyService {
  
  static const String baseUrl = 'http://localhost:5000/api'; 
                                                        

  Future<String> findnearbyService(String lat,String lng,String type) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/nearby/nearby'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'lat': lat,
          'lng': lng,
          'type': type,
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // The backend returns an array of places directly
        return jsonEncode(data);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Server error: ${errorData['error'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in findnearbyService: $e');
      if (e.toString().contains('Connection refused') || e.toString().contains('Failed host lookup')) {
        throw Exception('Cannot connect to server. Please make sure the backend server is running and accessible.');
      } else if (e.toString().contains('SocketException')) {
        throw Exception('Network error. Please check your internet connection.');
      } else {
        throw Exception('Failed to find nearby places: $e');
      }
    }
  }
}