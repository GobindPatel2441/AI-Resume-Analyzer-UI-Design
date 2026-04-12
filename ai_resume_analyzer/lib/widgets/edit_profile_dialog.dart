import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  String? _selectedRole;
  String? _selectedExperience;
  bool _isLoading = false;

  final List<String> _experiences = [
    'Entry Level (0-2 years)',
    'Mid Level (3-5 years)',
    'Senior (6-10 years)',
    'Expert (10+ years)',
  ];

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _nameController = TextEditingController(text: auth.userName ?? '');
    _emailController = TextEditingController(text: auth.userEmail ?? '');
    _phoneController = TextEditingController(text: auth.userPhone ?? '');
    _locationController = TextEditingController(text: auth.userLocation ?? '');
    _selectedRole = auth.targetRole;
    _selectedExperience = auth.experienceLevel;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.updateProfile(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _phoneController.text.trim(),
      _locationController.text.trim(),
      targetRole: _selectedRole,
      experienceLevel: _selectedExperience,
    );

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Update failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Personal Info Section
                _buildSectionHeader('Personal Information'),
                const SizedBox(height: 12),
                _buildLabel('Full Name'),
                TextFormField(
                  controller: _nameController,
                  validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                  decoration: const InputDecoration(hintText: 'Your name'),
                ),
                const SizedBox(height: 16),
                _buildLabel('Email'),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (!val.contains('@')) return 'Invalid email';
                    return null;
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Career Info Section
                _buildSectionHeader('Career Preferences'),
                const SizedBox(height: 12),
                _buildLabel('Target Role'),
                DropdownButtonFormField<String>(
                  value: AppConstants.popularJobRoles.contains(_selectedRole) ? _selectedRole : null,
                  hint: const Text('Select a job role'),
                  items: AppConstants.popularJobRoles.map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedRole = val),
                ),
                const SizedBox(height: 16),
                _buildLabel('Experience Level'),
                DropdownButtonFormField<String>(
                  value: _experiences.contains(_selectedExperience) ? _selectedExperience : null,
                  hint: const Text('Select experience level'),
                  items: _experiences.map((exp) {
                    return DropdownMenuItem(value: exp, child: Text(exp));
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedExperience = val),
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF8B80F9), // Purple from design
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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

  Widget _buildSectionHeader(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: AppTheme.primaryColor,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
