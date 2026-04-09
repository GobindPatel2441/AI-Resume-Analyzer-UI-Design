import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resume_provider.dart';
import '../login_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final resume = Provider.of<ResumeProvider>(context);
    final name = auth.userName ?? 'User';
    final email = auth.userEmail ?? '';

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
            ),
            const SizedBox(height: 32),

            // Avatar & Info
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'U',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(email,
                      style: const TextStyle(
                          color: AppTheme.textSecondaryColor, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Stats
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            '${resume.history.length}',
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor),
                          ),
                          const Text('Analyses',
                              style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            resume.history.isEmpty
                                ? '--'
                                : resume.avgScore.toStringAsFixed(0),
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                          const Text('Avg Score',
                              style: TextStyle(
                                  color: AppTheme.textSecondaryColor,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Options
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline,
                        color: AppTheme.primaryColor),
                    title: const Text('Account Info'),
                    subtitle: Text(email),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.bar_chart_rounded,
                        color: AppTheme.primaryColor),
                    title: const Text('My Analyses'),
                    subtitle: Text('${resume.history.length} total'),
                    trailing: const Icon(Icons.chevron_right),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading:
                        const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Log Out',
                        style: TextStyle(color: Colors.red)),
                    onTap: () async {
                      await auth.logout();
                      resume.clearHistory();
                      if (!context.mounted) return;
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
