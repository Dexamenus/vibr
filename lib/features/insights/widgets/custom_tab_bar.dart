import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../insights_screen.dart';

class CustomTabBar extends StatelessWidget {
  final InsightsTab selectedTab;
  final ValueChanged<InsightsTab> onTabChanged;

  const CustomTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _TabItem(
            label: 'Overview',
            icon: Icons.trending_up_rounded,
            selected: selectedTab == InsightsTab.overview,
            onTap: () => onTabChanged(InsightsTab.overview),
          ),
          _TabItem(
            label: 'Comments',
            icon: Icons.chat_bubble_outline,
            selected: selectedTab == InsightsTab.comments,
            onTap: () => onTabChanged(InsightsTab.comments),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 14,
                color: selected ? Colors.white : AppColors.muted,
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.muted,
                  fontSize: 13,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}