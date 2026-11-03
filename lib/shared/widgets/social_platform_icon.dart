import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class SocialPlatformIcon extends StatelessWidget {
  const SocialPlatformIcon({super.key, required this.platform, this.size = 19});

  final String platform;
  final double size;

  @override
  Widget build(BuildContext context) {
    final icon = switch (platform) {
      'Facebook' => Icons.facebook_rounded,
      'Instagram' => Icons.camera_alt_outlined,
      _ => Icons.public,
    };
    return Icon(icon, size: size, color: AppColors.muted);
  }
}
