import 'dart:convert';
import 'package:frontend/services/authService.dart';
import 'package:http/http.dart' as http;

class ApiService {
 
  static const String baseUrl = 'http://localhost:5000/api'; 
  final AuthService _authService = AuthService();
 

  Future<String> sendMessage(String message) async {
    try {
      final token = await _authService.getToken();
      
      if (token == null) {
        throw Exception('User not authenticated. Cannot send message.');
      }

      
      
      // final testResponse = await http.get(Uri.parse('$baseUrl/test'));
      // print('Test connection response: ${testResponse.statusCode}');
      
      // if (testResponse.statusCode != 200) {
      //   throw Exception('Backend server is not responding properly. Status: ${testResponse.statusCode}');
      // }

      final response = await http.post(
        Uri.parse('$baseUrl/ai/general/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization':'Bearer $token',



        },
        body: jsonEncode({
          'prompt': message,
          
        }),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'No response from AI';
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception('Server error: ${errorData['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      print('Error in sendMessage: $e');
      if (e.toString().contains('Connection refused')) {
        throw Exception('Cannot connect to server. Please make sure the backend server is running on port 5000.');
      } else if (e.toString().contains('SocketException')) {
        throw Exception('Network error. Please check your internet connection and make sure the backend server is running.');
      } else {
        throw Exception('Failed to send message: $e');
      }
    }
  }
} 