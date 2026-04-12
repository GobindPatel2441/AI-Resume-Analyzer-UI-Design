import 'dart:io';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'package:path_provider/path_provider.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _userName;
  String? _userEmail;
  String? _userId;
  String? _userPhone;
  String? _userLocation;
  String? _profilePicPath; 
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userId => _userId;
  String? get userPhone => _userPhone;
  String? get userLocation => _userLocation;
  String? get profilePicPath => _profilePicPath;
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
      
      // Load saved image path from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      _profilePicPath = prefs.getString(AppConstants.userProfilePicKey + "_local");
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
      
      // Attempt to load local path on explicit login
      final prefs = await SharedPreferences.getInstance();
      _profilePicPath = prefs.getString(AppConstants.userProfilePicKey + "_local");
      
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
    _profilePicPath = null;
    notifyListeners();
  }

  /// Updates the profile picture instantly using standard strict File logic.
  /// Copies the file to the app directory & saves the path permanently.
  Future<void> updateProfilePicture(File imageFile) async {
    try {
      // 1. Get Application Directory (path_provider)
      final directory = await getApplicationDocumentsDirectory();
      
      // 2. Create a permanent path
      final String persistentPath = '${directory.path}/profile_pic_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // 3. Copy the file
      final File savedImage = await imageFile.copy(persistentPath);
      
      // 4. Store the path in SharedPreferences permanently
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.userProfilePicKey + "_local", savedImage.path);

      // 5. Update UI instantly
      _profilePicPath = savedImage.path;
      notifyListeners(); 
      
    } catch (e) {
      debugPrint('[DEBUG] Error saving profile picture: $e');
    }
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
