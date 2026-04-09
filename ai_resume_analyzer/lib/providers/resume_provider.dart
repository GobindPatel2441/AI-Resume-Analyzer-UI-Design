import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/resume_analysis.dart';
import '../services/pdf_service.dart';
import '../services/openai_service.dart';
import '../services/history_service.dart';

class ResumeProvider with ChangeNotifier {
  PlatformFile? _selectedFile;
  String? _extractedText;
  String _targetRole = '';
  ResumeAnalysis? _currentAnalysis;
  List<ResumeAnalysis> _history = [];
  bool _isProcessing = false;
  bool _isLoadingHistory = false;
  String? _errorMessage;

  PlatformFile? get selectedFile => _selectedFile;
  String? get extractedText => _extractedText;
  String get targetRole => _targetRole;
  ResumeAnalysis? get currentAnalysis => _currentAnalysis;
  List<ResumeAnalysis> get history => _history;
  bool get isProcessing => _isProcessing;
  bool get isLoadingHistory => _isLoadingHistory;
  String? get errorMessage => _errorMessage;

  double get avgScore {
    if (_history.isEmpty) return 0;
    return _history.map((h) => h.score).reduce((a, b) => a + b) / _history.length;
  }

  void setTargetRole(String role) {
    _targetRole = role;
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

  /// Load history from backend
  Future<void> loadHistory() async {
    _isLoadingHistory = true;
    notifyListeners();

    try {
      _history = await HistoryService.getHistory();
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
      _currentAnalysis = await OpenAiService.analyzeResume(
        _extractedText!,
        _targetRole,
        _selectedFile!.name,
      );

      // 4. Update metadata
      _currentAnalysis = _currentAnalysis!.copyWith(
        resumeName: _selectedFile!.name,
        jobTitle: _targetRole,
      );

      // 5. Add to local history (backend also saves it)
      _history.insert(0, _currentAnalysis!);

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
}
