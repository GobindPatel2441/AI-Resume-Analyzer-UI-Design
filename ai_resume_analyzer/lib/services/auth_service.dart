import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class AuthService {
  // ── Signup ──────────────────────────────────────────────
  static Future<Map<String, dynamic>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.signupUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        await _persistSession(body);
        return {'success': true, 'user': body['user']};
      } else {
        return {'success': false, 'error': body['error'] ?? 'Signup failed'};
      }
    } catch (e) {
      debugPrint('AuthService.signup error: $e');
      return {'success': false, 'error': 'Cannot connect to server. Is the backend running?'};
    }
  }

  // ── Login ───────────────────────────────────────────────
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppConstants.loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 15));

      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await _persistSession(body);
        return {'success': true, 'user': body['user']};
      } else {
        return {'success': false, 'error': body['error'] ?? 'Login failed'};
      }
    } catch (e) {
      debugPrint('AuthService.login error: $e');
      return {'success': false, 'error': 'Cannot connect to server. Is the backend running?'};
    }
  }

  // ── Logout ──────────────────────────────────────────────
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.tokenKey);
    await prefs.remove(AppConstants.userNameKey);
    await prefs.remove(AppConstants.userEmailKey);
    await prefs.remove(AppConstants.userIdKey);
  }

  // ── Token helpers ───────────────────────────────────────
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.tokenKey);
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<Map<String, String?>> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getString(AppConstants.userIdKey),
      'name': prefs.getString(AppConstants.userNameKey),
      'email': prefs.getString(AppConstants.userEmailKey),
    };
  }

  // ── Private helpers ─────────────────────────────────────
  static Future<void> _persistSession(Map<String, dynamic> body) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.tokenKey, body['token'] ?? '');
    final user = body['user'] ?? {};
    await prefs.setString(AppConstants.userIdKey, user['id']?.toString() ?? '');
    await prefs.setString(AppConstants.userNameKey, user['name'] ?? '');
    await prefs.setString(AppConstants.userEmailKey, user['email'] ?? '');
  }
}
