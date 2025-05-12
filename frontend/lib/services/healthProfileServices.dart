import 'dart:convert';
import 'package:frontend/models/health_profile_model.dart';
import 'package:frontend/services/authService.dart'; // To get the authentication token
import 'package:http/http.dart' as http;

class HealthProfileService {
  
  final String _baseUrl = 'http://localhost:5000/api';
  final AuthService _authService = AuthService();

 
  Future<void> saveOrUpdateHealthProfile(HealthProfileModel profileData) async {
    final token = await _authService.getToken();
    if (token == null) {
      throw Exception('User not authenticated. Cannot save profile.');
    }

    
    final Uri url = Uri.parse('$_baseUrl/health/createUpdate'); // Example endpoint

    try {
      final response = await http.post( 
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', // Send the auth token
        },
        body: jsonEncode(profileData.toJson()), // Use the toJson method from your model
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Successfully saved or updated
        print('Health profile saved/updated successfully.');
        // Optionally, you could parse and return response.body if the backend sends back data
        // final responseData = jsonDecode(response.body);
        // return someValue;
      } else {
        // Handle server-side errors
        String errorMessage = 'Failed to save health profile. Status code: ${response.statusCode}';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? response.body;
        } catch (_) {
          // If response body is not JSON or doesn't have 'message'
          errorMessage = response.body.isNotEmpty ? response.body : errorMessage;
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Handle network errors or other exceptions during the request
      print('Error saving health profile: $e');
      if (e.toString().contains('Connection refused')) {
        throw Exception('Cannot connect to the server. Please ensure the backend is running.');
      }
      throw Exception('An error occurred while saving the health profile: ${e.toString()}');
    }
  }

  
}