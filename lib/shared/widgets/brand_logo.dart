import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 34 : 40,
          height: compact ? 34 : 40,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9A7BFF), Color(0xFF6F57F2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(11),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.28),
                blurRadius: 14,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: compact ? 19 : 23,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'SociAI',
          style: TextStyle(
            fontSize: compact ? 19 : 21,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}
