import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/resume_analysis.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';

class OpenAiService {
  static Future<ResumeAnalysis> analyzeResume(
    String resumeText,
    String jobRole,
    String resumeName,
  ) async {
    debugPrint('OpenAiService: Requesting analysis from backend for $jobRole...');

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
        debugPrint('OpenAiService: Analysis successfully received from backend.');
        return ResumeAnalysis.fromJson(jsonContent, jobRole, resumeName);
      } else {
        final body = jsonDecode(response.body);
        final errMsg = body['details'] ?? body['error'] ?? 'Unknown error';
        debugPrint('OpenAiService: BACKEND ERROR — $errMsg');
        throw Exception(errMsg);
      }
    } catch (e) {
      debugPrint('OpenAiService: EXCEPTION — $e');

      // Fallback mock for testing when backend is unreachable
      if (kIsWeb || e.toString().contains('connect')) {
        debugPrint('OpenAiService: Using mock result (backend unreachable)');
        await Future.delayed(const Duration(seconds: 2));
        return ResumeAnalysis(
          score: 78,
          matchPercentage: 78,
          extractedText: resumeText,
          summary:
              'MOCK (Backend unreachable): Strong candidate for $jobRole with solid technical background.',
          strengths: ['Technical skills', 'Problem solving', 'Communication'],
          weaknesses: ['Limited cloud experience', 'No leadership roles listed'],
          suggestions: [
            'Add quantified achievements (e.g., "Reduced build time by 40%")',
            'Include relevant certifications',
            'Expand leadership and collaboration examples',
          ],
          analysisDate: DateTime.now(),
          resumeName: resumeName,
          jobTitle: jobRole,
        );
      }

      throw Exception('Analysis failed: $e');
    }
  }
}
