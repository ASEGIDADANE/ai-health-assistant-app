// filepath: c:\Users\HP\Desktop\intagrate project\ai-health-assistant-app\frontend\lib\services\nerbyService.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class nearbyService {
  
  static const String baseUrl = 'http://10.0.2.2:5000/api'; 
                                                        

  Future<String> findnearbyService(String lat,String lng,String type) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/nearby/nearby'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'lat': lat,
          'lng': lng,
          'type': type // Corrected: use the 'type' parameter
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['response'] is String) {
          return data['response'];
        } else if (data['response'] != null) {
          
          return jsonEncode(data['response']);
        }
        return '[]'; 
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Server error: ${errorData['nearby'] ?? 'Unknown error'}');
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