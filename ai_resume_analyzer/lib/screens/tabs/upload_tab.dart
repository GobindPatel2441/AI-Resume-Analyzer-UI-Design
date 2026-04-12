import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../services/pdf_service.dart';
import '../../providers/resume_provider.dart';
import '../../widgets/custom_button.dart';
import '../processing_screen.dart';

class UploadTab extends StatefulWidget {
  const UploadTab({super.key});

  @override
  State<UploadTab> createState() => _UploadTabState();
}

class _UploadTabState extends State<UploadTab> {
  bool _isPicking = false;
  String? _error;

  void _onPickFile() async {
    setState(() {
      _isPicking = true;
      _error = null;
    });

    try {
      final file = await PdfService.pickPdf();
      if (file != null) {
        if (!mounted) return;
        Provider.of<ResumeProvider>(context, listen: false).selectFile(file);
        setState(() {
          _isPicking = false;
        });
      } else {
        setState(() => _isPicking = false);
      }
    } catch (e, stack) {
      debugPrint("UploadTab: Selection FATAL EXCEPTION: $e");
      debugPrint("UploadTab: Stack trace: $stack");
      setState(() {
        _error = "Details: $e";
        _isPicking = false;
      });
    }
  }

  void _onAnalyze() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ProcessingScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResumeProvider>(context);
    final selectedFile = provider.selectedFile;
    
    String? fileName = selectedFile?.name;
    String? fileSize;
    if (selectedFile != null) {
      fileSize = (selectedFile.size / 1024 / 1024).toStringAsFixed(2) + ' MB';
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Resume',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: InkWell(
                onTap: _isPicking ? null : _onPickFile,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    border: Border.all(
                      color: selectedFile != null ? AppTheme.primaryColor : AppTheme.primaryColor.withValues(alpha: 0.3),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          selectedFile != null ? Icons.check_circle_rounded : Icons.cloud_upload_rounded,
                          size: 64,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        selectedFile != null ? 'File Selected' : 'Tap to Upload PDF',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      if (fileName != null) ...[
                        Text(fileName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(fileSize!, style: const TextStyle(color: AppTheme.textSecondaryColor)),
                      ] else ...[
                        const Text('Max size: 5MB', style: TextStyle(color: AppTheme.textSecondaryColor)),
                      ],
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Text(_error!, style: const TextStyle(color: Colors.red)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Analyze Resume',
              onPressed: selectedFile != null ? _onAnalyze : null,
              isLoading: _isPicking,
            ),
          ],
        ),
      ),
    );
  }
}
