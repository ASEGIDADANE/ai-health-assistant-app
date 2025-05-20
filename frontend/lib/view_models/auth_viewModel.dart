import 'package:flutter/foundation.dart';
import 'package:frontend/services/authService.dart';


class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  bool _isProfileCompleted = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  bool get isProfileCompleted => _isProfileCompleted;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
     final response =   await _authService.login(email, password);
      _isAuthenticated = true;
      _isLoading = false;
      _isProfileCompleted = response['profileCompleted'] ?? false;
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
      final response = await _authService.signup(email, password);
      _isAuthenticated = true;
    _isProfileCompleted = response['profileCompleted'] ?? false;
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
    _isProfileCompleted = false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    final token = await _authService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }
}
