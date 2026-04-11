import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/resume_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'main_screen.dart';

class JobRoleScreen extends StatefulWidget {
  const JobRoleScreen({super.key});

  @override
  State<JobRoleScreen> createState() => _JobRoleScreenState();
}

class _JobRoleScreenState extends State<JobRoleScreen> {
  final _roleController = TextEditingController();
  String? _selectedChip;

  @override
  void dispose() {
    _roleController.dispose();
    super.dispose();
  }

  void _continue() {
    final role = _roleController.text.trim().isNotEmpty
        ? _roleController.text.trim()
        : _selectedChip;

    if (role == null || role.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select or enter a target job role'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Provider.of<ResumeProvider>(context, listen: false).setTargetRole(role);
    Provider.of<ResumeProvider>(context, listen: false).loadHistory();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final name = auth.userName ?? 'there';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Hello, $name! 👋',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'What role are you\ntargeting?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _roleController,
                  decoration: const InputDecoration(
                    labelText: 'e.g. Senior Flutter Developer',
                    prefixIcon: Icon(Icons.search),
                    helperText: 'Or pick from popular roles below',
                  ),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _continue(),
                  onChanged: (_) => setState(() => _selectedChip = null),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AppConstants.popularJobRoles.map((role) {
                    final isSelected = _selectedChip == role;
                    return FilterChip(
                      label: Text(role),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() {
                          _selectedChip = val ? role : null;
                          if (val) _roleController.clear();
                        });
                      },
                      selectedColor: AppTheme.primaryColor.withValues(alpha: 0.15),
                      checkmarkColor: AppTheme.primaryColor,
                      labelStyle: TextStyle(
                        color: isSelected ? AppTheme.primaryColor : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                  ),
                  child: const Text(
                    'Continue to Dashboard',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
