import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../widgets/score_indicator.dart';
import '../widgets/custom_button.dart';
import '../providers/resume_provider.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResumeProvider>(context);
    final analysis = provider.currentAnalysis;

    if (analysis == null) {
      return const Scaffold(
        body: Center(child: Text('No analysis found')),
      );
    }

    double score = analysis.score.toDouble();
    String summary = analysis.summary;
    List<String> strengths = analysis.strengths;
    List<String> weaknesses = analysis.weaknesses;
    List<String> suggestions = analysis.suggestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.textPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ScoreIndicator(score: score),
            const SizedBox(height: 12),
            Text(
              analysis.jobTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 32),
            // Summary Section
            _buildSection(
              context,
              'Professional Summary',
              Icons.description_rounded,
              Colors.purple,
              Text(
                summary,
                style: const TextStyle(fontSize: 14, color: AppTheme.textSecondaryColor, height: 1.5),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              'Key Strengths',
              Icons.check_circle_rounded,
              Colors.green,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: strengths.map((s) => Chip(
                  label: Text(s),
                  backgroundColor: Colors.green.shade50,
                  labelStyle: const TextStyle(color: Colors.green, fontSize: 12),
                  side: BorderSide.none,
                )).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              'Critical Weaknesses',
              Icons.warning_rounded,
              Colors.orange,
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: weaknesses.map((w) => Chip(
                  label: Text(w),
                  backgroundColor: Colors.orange.shade50,
                  labelStyle: const TextStyle(color: Colors.orange, fontSize: 12),
                  side: BorderSide.none,
                )).toList(),
              ),
            ),
            const SizedBox(height: 16),
            _buildSection(
              context,
              'Improvement Suggestions',
              Icons.lightbulb_rounded,
              Colors.blue,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: suggestions.map((s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle, size: 8, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          s,
                          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondaryColor),
                        ),
                      ),
                    ],
                  ),
                )).toList(),
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Done',
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, Color color, Widget content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }
}
