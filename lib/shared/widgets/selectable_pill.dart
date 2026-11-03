import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class SelectablePill extends StatelessWidget {
  const SelectablePill({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.count,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(count == null ? label : '$label $count'),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.accentSoft,
      side: BorderSide(color: selected ? AppColors.accent : AppColors.border),
      labelStyle: TextStyle(
        color: selected ? const Color(0xFFD8CCFF) : AppColors.muted,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
      shape: const StadiumBorder(),
    );
  }
}
