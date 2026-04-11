import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resume_provider.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/edit_profile_dialog.dart';
import '../../widgets/change_password_dialog.dart';
import '../login_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final resume = Provider.of<ResumeProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
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

            // Account Section
            Text(
              'Account',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_outline),
                    ),
                    title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const EditProfileDialog(),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock_outline),
                    ),
                    title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.w500)),
                    trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => const ChangePasswordDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Preferences Section
            Text(
              'Preferences',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                secondary: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(microseconds: 200),
                    transitionBuilder: (child, anim) => RotationTransition(
                      turns: anim,
                      child: ScaleTransition(scale: anim, child: child),
                    ),
                    child: Icon(
                      themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                      key: ValueKey(themeProvider.themeMode),
                      color: themeProvider.themeMode == ThemeMode.dark ? AppTheme.primaryColor : Colors.grey.shade600,
                    ),
                  ),
                ),
                title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.w600)),
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (bool value) {
                  themeProvider.toggleTheme(value);
                },
                activeColor: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),

            // General Section
            Text(
              'General',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimaryColor,
                  ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
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
