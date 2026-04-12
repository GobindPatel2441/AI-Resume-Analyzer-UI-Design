import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/app_theme.dart';

class ProfileAvatar extends StatelessWidget {
  final double radius;
  final double? fontSize;

  const ProfileAvatar({
    super.key,
    required this.radius,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final name = auth.userName ?? 'U';
    
    // Determine ImageProvider based on local file existence
    ImageProvider? imageProvider;
    if (auth.profilePicPath != null && File(auth.profilePicPath!).existsSync()) {
      imageProvider = FileImage(File(auth.profilePicPath!));
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? Text(
              name.isNotEmpty ? name[0].toUpperCase() : 'U',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontSize: fontSize ?? (radius * 0.8),
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }
}
