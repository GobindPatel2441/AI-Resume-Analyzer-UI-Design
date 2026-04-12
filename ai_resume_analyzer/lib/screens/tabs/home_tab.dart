import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/resume_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/navigation_provider.dart';
import '../../widgets/resume_tile.dart';
import '../../widgets/shimmer_loading.dart';
import '../../widgets/profile_avatar.dart';
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

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => provider.loadHistory(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
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
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 28,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            auth.userName != null
                                ? 'Welcome back, ${auth.userName}!'
                                : 'Welcome back!',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white24
                                : Colors.white,
                            width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    child: InkWell(
                      onTap: () => Provider.of<NavigationProvider>(context, listen: false).setIndex(3),
                      borderRadius: BorderRadius.circular(24),
                      child: const ProfileAvatar(
                        radius: 24,
                        fontSize: 18,
                      ),
                    ),

                    ),
                  ],
                ),
                const SizedBox(height: 32),
    
                // Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        icon: Icons.description_outlined,
                        label: 'Analyzed',
                        value: '$totalAnalyzed',
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _StatCard(
                        icon: Icons.bolt_rounded,
                        label: 'Avg Score',
                        value: totalAnalyzed > 0 ? avgScore.toStringAsFixed(0) : '--',
                        color: avgScore >= 80
                            ? AppTheme.accentColor
                            : avgScore >= 60
                                ? Colors.orange
                                : AppTheme.errorColor,
                      ),
                    ),
                  ],
                ),
    
                if (history.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  // Latest Score Banner (Premium Card)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Latest ATS Score',
                        style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${history.first.score}%',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        history.first.resumeName,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Center(
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: const Icon(Icons.trending_up_rounded, color: Colors.white, size: 48),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
    
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Recent Analyses',
                        style: Theme.of(context).textTheme.titleLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (history.length > 5)
                      TextButton(
                        onPressed: () => Provider.of<NavigationProvider>(context, listen: false).setIndex(2),
                        child: const Text('View All'),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
    
                if (provider.isLoadingHistory)
                  Column(
                    children: List.generate(3, (index) => const Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: ShimmerLoading.rectangular(height: 80),
                    )),
                  )
                else if (history.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 48),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade800
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.analytics_outlined,
                              size: 64,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey.shade600
                                  : Colors.grey.shade300),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'No resumes analyzed yet',
                          style: TextStyle(color: AppTheme.textSecondaryColor, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => Provider.of<NavigationProvider>(context, listen: false).setIndex(1),
                          child: const Text('Start your first analysis'),
                        ),
                      ],
                    ),
                  )
                else
                  ...history.take(5).map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: ResumeTile(
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
                      ),
              ],
            ),
          ),
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
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                    fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
