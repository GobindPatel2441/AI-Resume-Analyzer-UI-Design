import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/resume_analysis.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class AnalysisService {
  static Future<ResumeAnalysis> analyzeResume(
    String resumeText,
    String jobRole,
    String resumeName,
  ) async {
    debugPrint('AnalysisService: Requesting analysis from backend for $jobRole...');

    try {
      final token = await AuthService.getToken();

      final response = await http.post(
        Uri.parse(AppConstants.analyzeUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'resumeText': resumeText,
          'jobRole': jobRole,
          'resumeName': resumeName,
        }),
      ).timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonContent = jsonDecode(response.body);
        debugPrint('AnalysisService: Analysis successfully received from backend.');
        return ResumeAnalysis.fromJson(jsonContent, jobRole, resumeName);
      } else {
        final body = jsonDecode(response.body);
        final errMsg = body['details'] ?? body['error'] ?? 'Unknown error';
        debugPrint('AnalysisService: BACKEND ERROR — $errMsg');
        throw Exception(errMsg);
      }
    } catch (e) {
      debugPrint('AnalysisService: catch block — $e');
      throw Exception('Server unreachable or error occurred: $e');
    }
  }
}
