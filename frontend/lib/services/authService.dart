
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart'; // Import the JWT decoder
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://localhost:5000/api';
  // final String baseUrl = 'http://13.60.23.17:5000/api/';


  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );
      print('Login Response : ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String accessToken = data['accessToken'];
        await _saveToken(accessToken);

        // Decode token and save userId
        try {
          Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
          // IMPORTANT: Your backend uses 'userId' in the JWT payload.
          if (decodedToken.containsKey('userId')) {
            String userIdFromToken = decodedToken['userId'];
            await _saveUserId(userIdFromToken);
            print('User ID from token (login): $userIdFromToken');
          } else {
            print('Warning: "userId" claim not found in JWT token payload during login.');
            // Optionally, handle if the response structure might still have user.id directly
            // if (data['user'] != null && data['user']['id'] != null) {
            //   await _saveUserId(data['user']['id']);
            // }
          }
        } catch (e) {
          print('Error decoding token during login: $e');
          // Optionally, handle if the response structure might still have user.id directly
          // if (data['user'] != null && data['user']['id'] != null) {
          //   await _saveUserId(data['user']['id']);
          // }
        }
        // return data;
        // corrected data---
         return {
          'accessToken': accessToken,
          'profileCompleted': data['profileCompleted'] ?? false,
           // Pass the whole user object
        };

        
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Login failed');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Failed to connect to server or login failed');
    }
  }

  Future<Map<String, dynamic>> signup(String email, String password) async { // Added name parameter
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password
           // Added name to signup request
        }),
      );
      print('Signup Response : ${response.body}');

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final String accessToken = data['accessToken']; // Assuming signup also returns accessToken
        await _saveToken(accessToken);

        // Decode token and save userId
        try {
          Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
          // IMPORTANT: Your backend uses 'userId' in the JWT payload.
          if (decodedToken.containsKey('userId')) {
            String userIdFromToken = decodedToken['userId'];
            await _saveUserId(userIdFromToken);
            print('User ID from token (signup): $userIdFromToken');
          } else {
            print('Warning: "userId" claim not found in JWT token payload during signup.');
          }
        } catch (e) {
          print('Error decoding token during signup: $e');
        }
        // return data;
        // current changee ---
         return {
          'accessToken': accessToken,
          'profileCompleted': data['profileCompleted'] ?? false,
           // Pass the whole user object
        };
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Signup failed');
      }
    } catch (e) {
      print('Signup error: $e');
      throw Exception('Failed to connect to server or signup failed');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('userId'); // Also remove userId on logout
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

  // Method to retrieve the saved userId
  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    // You might also want to check if userId exists or if token is not expired
    return token != null;
  }
}