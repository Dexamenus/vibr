import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/primary_button.dart';

class ScheduleEmptyState extends StatelessWidget {
  const ScheduleEmptyState({super.key, required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            color: AppColors.accent,
            size: 25,
          ),
          const SizedBox(height: 10),
          const Text(
            'Ada ruang untuk ide berikutnya',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Belum ada yang dijadwalkan untuk hari ini.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.muted, fontSize: 11),
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Jadwalkan postingan pertama',
            icon: Icons.add_rounded,
            onPressed: onCreate,
          ),
        ],
      ),
    );
  }
}
