import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/resume_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/resume_tile.dart';
import '../results_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ResumeProvider>(context);
    final auth = Provider.of<AuthProvider>(context);
    final history = provider.history;
    final totalAnalyzed = history.length;
    final avgScore = provider.avgScore;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimaryColor,
                            ),
                      ),
                      Text(
                        auth.userName != null
                            ? 'Welcome back, ${auth.userName}!'
                            : 'Welcome back!',
                        style: const TextStyle(
                            color: AppTheme.textSecondaryColor, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor,
                  child: Text(
                    auth.userName?.isNotEmpty == true
                        ? auth.userName![0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.description_rounded,
                    label: 'Analyzed',
                    value: '$totalAnalyzed',
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.bar_chart_rounded,
                    label: 'Avg Score',
                    value: totalAnalyzed > 0 ? avgScore.toStringAsFixed(0) : '--',
                    color: avgScore >= 80
                        ? Colors.green
                        : avgScore >= 60
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
              ],
            ),

            if (history.isNotEmpty) ...[
              const SizedBox(height: 24),
              // Latest Score Banner
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Latest ATS Score',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${history.first.score}/100',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          history.first.resumeName,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const Spacer(),
                    CircularProgressIndicator(
                      value: history.first.score / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.white24,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
            const Text(
              'Recent Analyses',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimaryColor),
            ),
            const SizedBox(height: 16),

            if (provider.isLoadingHistory)
              const Center(child: CircularProgressIndicator())
            else if (history.isEmpty)
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Icon(Icons.query_stats_rounded,
                        size: 80, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    const Text(
                      'No resumes analyzed yet',
                      style: TextStyle(color: AppTheme.textSecondaryColor),
                    ),
                    const Text(
                      'Go to Upload to get started!',
                      style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              )
            else
              ...history.take(5).map(
                    (item) => ResumeTile(
                      title: item.resumeName,
                      subtitle: item.jobTitle,
                      score: item.score.toDouble(),
                      onTap: () {
                        provider.setCurrentAnalysis(item);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ResultsScreen()),
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

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: color),
            ),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textSecondaryColor, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
