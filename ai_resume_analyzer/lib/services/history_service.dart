import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/resume_analysis.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class HistoryService {
  static Future<List<ResumeAnalysis>> getHistory() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return [];

      final response = await http.get(
        Uri.parse(AppConstants.historyUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((item) => ResumeAnalysis.fromHistoryJson(item)).toList();
      }
    } catch (e) {
      debugPrint('HistoryService.getHistory error: $e');
    }
    return [];
  }

  static Future<bool> deleteHistory(String id) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return false;

      final response = await http.delete(
        Uri.parse('${AppConstants.historyUrl}/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('HistoryService.deleteHistory error: $e');
      return false;
    }
  }
}
