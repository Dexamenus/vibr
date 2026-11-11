import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.expand = true,
    this.showIcon = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool expand;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.5),
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      elevation: 0,
    );
    final child = SizedBox(
      height: 54,
      child: showIcon
          ? FilledButton.icon(
              onPressed: onPressed,
              icon: isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(icon ?? Icons.arrow_forward_rounded, size: 19),
              label: Text(label),
              style: style,
            )
          : FilledButton(
              onPressed: onPressed,
              style: style,
              child: isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(label),
            ),
    );
    return expand ? SizedBox(width: double.infinity, child: child) : child;
  }
}
