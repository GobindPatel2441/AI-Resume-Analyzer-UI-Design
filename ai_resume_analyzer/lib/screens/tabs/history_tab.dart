import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/resume_provider.dart';
import '../../widgets/resume_tile.dart';
import '../../widgets/shimmer_loading.dart';
import '../results_screen.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResumeProvider>(context);
    final history = provider.history;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Analysis History',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimaryColor,
                        ),
                  ),
                ),
                if (history.isNotEmpty)
                  Text(
                    '${history.length} records',
                    style: const TextStyle(
                        color: AppTheme.textSecondaryColor, fontSize: 13),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: provider.isLoadingHistory
                  ? ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: ShimmerLoading.rectangular(height: 80),
                      ),
                    )
                  : history.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history_rounded,
                                  size: 80, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              const Text('No previous analyses found',
                                  style: TextStyle(
                                      color: AppTheme.textSecondaryColor)),
                              const Text(
                                'Upload a resume to get started!',
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final item = history[index];
                            return ResumeTile(
                              title: item.resumeName,
                              subtitle: item.jobTitle,
                              score: item.score.toDouble(),
                              date: item.analysisDate,
                              onTap: () {
                                provider.setCurrentAnalysis(item);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const ResultsScreen()),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
