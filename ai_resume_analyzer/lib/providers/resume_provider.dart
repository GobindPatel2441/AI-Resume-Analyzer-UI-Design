import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/resume_analysis.dart';
import '../services/pdf_service.dart';
import '../services/analysis_service.dart';
import '../services/history_service.dart';

class ResumeProvider with ChangeNotifier {
  PlatformFile? _selectedFile;
  String? _extractedText;
  String _targetRole = '';
  String _experienceLevel = '';
  ResumeAnalysis? _currentAnalysis;
  List<ResumeAnalysis> _history = [];
  bool _isProcessing = false;
  bool _isLoadingHistory = false;
  String? _errorMessage;

  PlatformFile? get selectedFile => _selectedFile;
  String? get extractedText => _extractedText;
  String get targetRole => _targetRole;
  String get experienceLevel => _experienceLevel;
  ResumeAnalysis? get currentAnalysis => _currentAnalysis;
  List<ResumeAnalysis> get history => _history;
  bool get isProcessing => _isProcessing;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get errorMessage => _errorMessage;

  double get avgScore {
    if (_history.isEmpty) return 0;
    return _history.map((h) => h.score).reduce((a, b) => a + b) / _history.length;
  }

  void setTargetRole(String role, {String experience = ''}) {
    _targetRole = role;
    _experienceLevel = experience;
    notifyListeners();
  }

  void selectFile(PlatformFile file) {
    _selectedFile = file;
    notifyListeners();
  }

  void setCurrentAnalysis(ResumeAnalysis analysis) {
    _currentAnalysis = analysis;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearHistory() {
    _history = [];
    _currentAnalysis = null;
    _selectedFile = null;
    _extractedText = null;
    notifyListeners();
  }

  /// Save history silently to SharedPreferences
  Future<void> _saveHistoryLocally() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(_history.map((e) => e.toMap()).toList());
      await prefs.setString('cached_history', encoded);
    } catch (e) {
      debugPrint('Error saving local history: $e');
    }
  }

  /// Load history from backend, falling back to instant local cache first
  Future<void> loadHistory() async {
    _isLoadingHistory = true;
    notifyListeners();

    // 1. Instant load from local cache first
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedStr = prefs.getString('cached_history');
      if (cachedStr != null) {
        final List<dynamic> decoded = jsonDecode(cachedStr);
        _history = decoded.map((e) => ResumeAnalysis.fromMap(e)).toList();
        _isLoadingHistory = false;
        notifyListeners(); // UI updates instantly!
      }
    } catch (e) {
      debugPrint('Error loading local history cache: $e');
    }

    // 2. Background sync with backend
    try {
      final serverHistory = await HistoryService.getHistory();
      // Only rebuild if the server history is different (rough check via length or just blindly update)
      _history = serverHistory;
      await _saveHistoryLocally();
    } catch (e) {
      debugPrint('ResumeProvider.loadHistory error: $e');
    }

    _isLoadingHistory = false;
    notifyListeners();
  }

  /// Full analysis flow
  Future<void> analyzeResume() async {
    if (_selectedFile == null || _selectedFile!.bytes == null) return;

    _isProcessing = true;
    _errorMessage = null;
    notifyListeners();

    try {
      debugPrint('ResumeProvider: Starting analysis...');

      // 1. Extract text
      _extractedText = await PdfService.extractText(_selectedFile!.bytes!);

      // 2. Clear previous
      _currentAnalysis = null;
      notifyListeners();

      // 3. Analyze via backend
      final combinedRole = _experienceLevel.isNotEmpty 
          ? '$_targetRole ($_experienceLevel)' 
          : _targetRole;
          
      _currentAnalysis = await AnalysisService.analyzeResume(
        _extractedText!,
        combinedRole,
        _selectedFile!.name,
      );

      // 4. Update metadata
      _currentAnalysis = _currentAnalysis!.copyWith(
        resumeName: _selectedFile!.name,
        jobTitle: combinedRole,
      );

      // 5. Add to local history (backend also saves it)
      _history.insert(0, _currentAnalysis!);
      await _saveHistoryLocally();

      _isProcessing = false;
      debugPrint('ResumeProvider: Analysis complete. Score: ${_currentAnalysis!.score}');
      notifyListeners();
    } catch (e) {
      _isProcessing = false;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      debugPrint('ResumeProvider: FATAL ERROR — $_errorMessage');
      notifyListeners();
      rethrow;
    }
  }
  Future<bool> deleteAnalysis(String id) async {
    final success = await HistoryService.deleteHistory(id);
    if (success) {
      _history.removeWhere((item) => item.id == id);
      if (_currentAnalysis?.id == id) {
        _currentAnalysis = null;
      }
      await _saveHistoryLocally();
      notifyListeners();
    }
    return success;
  }
}
