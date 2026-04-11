import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _userName;
  String? _userEmail;
  String? _userId;
  String? _userPhone;
  String? _userLocation;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  String? get userPhone => _userPhone;
  String? get userLocation => _userLocation;
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
      _userPhone = user['phone'];
      _userLocation = user['location'];
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
      _userPhone = user['phone']?.toString();
      _userLocation = user['location']?.toString();
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
      _userPhone = user['phone']?.toString();
      _userLocation = user['location']?.toString();
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
    _userPhone = null;
    _userLocation = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> updateProfile(String name, String email, String phone, String location) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await AuthService.updateProfile(
        name: name, email: email, phone: phone, location: location);

    _isLoading = false;
    if (result['success'] == true) {
      final user = result['user'] as Map<String, dynamic>;
      _userName = user['name']?.toString();
      _userEmail = user['email']?.toString();
      _userPhone = user['phone']?.toString();
      _userLocation = user['location']?.toString();
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['error']?.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await AuthService.changePassword(
        currentPassword: currentPassword, newPassword: newPassword);

    _isLoading = false;
    if (result['success'] == true) {
      notifyListeners();
      return true;
    } else {
      _errorMessage = result['error']?.toString();
      notifyListeners();
      return false;
    }
  }
}
