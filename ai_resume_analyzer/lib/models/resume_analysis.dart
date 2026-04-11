class ResumeAnalysis {
  final String? id;
  final String resumeName;
  final String extractedText;
  final String jobTitle;
  final int score;
  final double matchPercentage;
  final String summary;
  final List<String> strengths;
  final List<String> weaknesses;
  final List<String> suggestions;
  final DateTime analysisDate;

  ResumeAnalysis({
    this.id,
    required this.resumeName,
    required this.extractedText,
    required this.jobTitle,
    required this.score,
    required this.matchPercentage,
    required this.summary,
    required this.strengths,
    required this.weaknesses,
    required this.suggestions,
    required this.analysisDate,
  });

  /// From backend `/analyze-resume` response
  factory ResumeAnalysis.fromJson(
    Map<String, dynamic> json,
    String jobTitle,
    String resumeName,
  ) {
    return ResumeAnalysis(
      id: json['historyId']?.toString() ?? json['_id']?.toString(),
      resumeName: resumeName,
      extractedText: '',
      jobTitle: jobTitle,
      score: _parseInt(json['score']),
      matchPercentage: _parseDouble(json['score']),
      summary: json['summary']?.toString() ?? '',
      strengths: _parseList(json['strengths']),
      weaknesses: _parseList(json['weaknesses']),
      suggestions: _parseList(json['suggestions']),
      analysisDate: DateTime.now(),
    );
  }

  /// From backend `/analyze-resume/history` response
  factory ResumeAnalysis.fromHistoryJson(Map<String, dynamic> json) {
    return ResumeAnalysis(
      id: json['_id']?.toString(),
      resumeName: json['resumeName']?.toString() ?? 'Untitled',
      extractedText: '',
      jobTitle: json['jobTitle']?.toString() ?? '',
      score: _parseInt(json['score']),
      matchPercentage: _parseDouble(json['matchPercentage'] ?? json['score']),
      summary: json['summary']?.toString() ?? '',
      strengths: _parseList(json['strengths']),
      weaknesses: _parseList(json['weaknesses']),
      suggestions: _parseList(json['suggestions']),
      analysisDate: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  /// From local SharedPreferences cache
  factory ResumeAnalysis.fromMap(Map<String, dynamic> map) {
    return ResumeAnalysis(
      id: map['id']?.toString(),
      resumeName: map['resume_name']?.toString() ?? 'Untitled',
      extractedText: map['extracted_text']?.toString() ?? '',
      jobTitle: map['job_title']?.toString() ?? '',
      score: _parseInt(map['score']),
      matchPercentage: _parseDouble(map['match_percentage']),
      summary: map['summary']?.toString() ?? '',
      strengths: _parseList(map['strengths']),
      weaknesses: _parseList(map['weaknesses']),
      suggestions: _parseList(map['suggestions']),
      analysisDate: map['analysis_date'] != null
          ? DateTime.tryParse(map['analysis_date'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'resume_name': resumeName,
      'extracted_text': extractedText,
      'job_title': jobTitle,
      'score': score,
      'match_percentage': matchPercentage,
      'summary': summary,
      'strengths': strengths,
      'weaknesses': weaknesses,
      'suggestions': suggestions,
      'analysis_date': analysisDate.toIso8601String(),
    };
  }

  ResumeAnalysis copyWith({
    String? id,
    String? resumeName,
    String? extractedText,
    String? jobTitle,
    int? score,
    double? matchPercentage,
    String? summary,
    List<String>? strengths,
    List<String>? weaknesses,
    List<String>? suggestions,
    DateTime? analysisDate,
  }) {
    return ResumeAnalysis(
      id: id ?? this.id,
      resumeName: resumeName ?? this.resumeName,
      extractedText: extractedText ?? this.extractedText,
      jobTitle: jobTitle ?? this.jobTitle,
      score: score ?? this.score,
      matchPercentage: matchPercentage ?? this.matchPercentage,
      summary: summary ?? this.summary,
      strengths: strengths ?? this.strengths,
      weaknesses: weaknesses ?? this.weaknesses,
      suggestions: suggestions ?? this.suggestions,
      analysisDate: analysisDate ?? this.analysisDate,
    );
  }

  // ── Helpers ─────────────────────────────────────────────
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static List<String> _parseList(dynamic value) {
    if (value == null) return [];
    if (value is List) return value.map((e) => e.toString()).toList();
    return [];
  }
}
