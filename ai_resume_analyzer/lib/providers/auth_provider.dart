import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _userName;
  String? _userEmail;
  String? _userId;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  String? get errorMessage => _errorMessage;

  /// Called on app startup to restore session
  Future<void> restoreSession() async {
    _isLoading = true;
    notifyListeners();

    final loggedIn = await AuthService.isLoggedIn();
    if (loggedIn) {
      final user = await AuthService.getSavedUser();
      _isLoggedIn = true;
      _userName = user['name'];
      _userEmail = user['email'];
      _userId = user['id'];
    } else {
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await AuthService.login(email: email, password: password);

    _isLoading = false;
    if (result['success'] == true) {
      final user = result['user'] as Map<String, dynamic>;
      _isLoggedIn = true;
      _userName = user['name']?.toString();
      _userEmail = user['email']?.toString();
      _userId = user['id']?.toString();
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['error']?.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result =
        await AuthService.signup(name: name, email: email, password: password);

    _isLoading = false;
    if (result['success'] == true) {
      final user = result['user'] as Map<String, dynamic>;
      _isLoggedIn = true;
      _userName = user['name']?.toString();
      _userEmail = user['email']?.toString();
      _userId = user['id']?.toString();
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['error']?.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _isLoggedIn = false;
    _userName = null;
    _userEmail = null;
    _userId = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
