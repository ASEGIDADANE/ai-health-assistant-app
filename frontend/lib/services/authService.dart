


import 'dart:convert';
import 'package:http/http.dart' as http;

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
      print('Response : ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await _saveToken(data['accessToken']);
        // if(data['user']['id'] != null) {
        //   await _saveUserId(data['user']['id']);
        // }
        return data;
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        await _saveToken(data['accessToken']);
        // if(data['user']['id'] != null) {
        //   await _saveUserId(data['user']['id']);
        // }
        return data;
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Signup failed');
      }
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }
   Future<String?> getUserId() async { // New method to get userId
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> _saveUserId(String userId) async { // New method to save userId
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
  }
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }

}