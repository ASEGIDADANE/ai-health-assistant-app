// import 'package:flutter/material.dart';
// import 'package:frontend/services/authService.dart';
// import '../models/user_model.dart';


// class AuthViewModel extends ChangeNotifier {
//   final AuthService _authService = AuthService();
//   User? _currentUser;
//   bool _isLoading = false;
//   String? _error;

//   User? get currentUser => _currentUser;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   bool get isAuthenticated => _currentUser != null;

//   AuthViewModel() {
//     _loadCurrentUser();
//   }

//   Future<void> _loadCurrentUser() async {
//     _currentUser = await _authService.getCurrentUser();
//     notifyListeners();
//   }

//   Future<bool> signUp({
//     required String email,
//     required String password,
   
//   }) async {
//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();

//       final response = await _authService.signUp(
//         email: email,
//         password: password,
       
//       );

//       _currentUser = User.fromJson(response['user']);
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//       return false;
//     }
//   }

//   Future<bool> signIn({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();

//       final response = await _authService.signIn(
//         email: email,
//         password: password,
//       );

//       _currentUser = User.fromJson(response['user']);
//       _isLoading = false;
//       notifyListeners();
//       return true;
//     } catch (e) {
//       _isLoading = false;
//       _error = e.toString();
//       notifyListeners();
//       return false;
//     }
//   }

//   Future<void> signOut() async {
//     await _authService.signOut();
//     _currentUser = null;
//     notifyListeners();
//   }

//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }
// }


import 'package:flutter/foundation.dart';
import 'package:frontend/services/authService.dart';


class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.login(email, password);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.signup(email, password);
      _isAuthenticated = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final token = await _authService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }
}