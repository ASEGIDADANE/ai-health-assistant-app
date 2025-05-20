// services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/health_snippet_model.dart'; // Adjust path if needed

class ApiService {
  // Ensure this matches your Express server's address
  // For Android emulator, use 10.0.2.2 for localhost
  // For iOS simulator or physical device on same network, use your computer's local IP
  final String _baseUrl =
      "http://localhost:5000/api"; // Or your actual IP/domain

  Future<HealthSnippet?> fetchDailySnippet() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/healthsnippets/snippet'),
      );

      if (response.statusCode == 200) {
        return HealthSnippet.fromJson(jsonDecode(response.body));
      } else {
        // Handle server errors (e.g., log them, return null)
        print('Failed to load snippet: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle network errors or other exceptions
      print('Error fetching snippet: $e');
      return null;
    }
  }
}
