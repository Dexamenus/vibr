import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/primary_button.dart';

// --- Global UI Helpers untuk filter ---

class FilterButton extends StatelessWidget {
  final VoidCallback onTap;
  const FilterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: const SizedBox(
          width: 38,
          height: 38,
          child: Icon(Icons.tune_rounded, size: 20),
        ),
      ),
    );
  }
}

Widget sheetHeading(BuildContext context, String title, String subtitle) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: AppColors.muted, fontSize: 13),
            ),
          ],
        ),
      ),
      IconButton(
        onPressed: () => Navigator.pop(context),
        visualDensity: VisualDensity.compact,
        icon: const Icon(Icons.cancel_outlined, size: 20),
      ),
    ],
  );
}

Widget optionPill({
  required String label,
  required bool selected,
  required VoidCallback onTap,
  bool expand = false,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(24),
    child: Container(
      width: expand ? double.infinity : null,
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? AppColors.surfaceRaised : Colors.transparent,
        border: Border.all(
          color: selected ? AppColors.accent : AppColors.border,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment:
            expand ? MainAxisAlignment.start : MainAxisAlignment.center,
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: [
          if (selected) ...[
            const Icon(Icons.check_rounded, color: AppColors.accent, size: 16),
            const SizedBox(width: 7),
          ],
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    ),
  );
}

// --- Sheets ---

class AnalyticsFilterSheet extends StatefulWidget {
  final int initialDays;
  final String initialPlatform;

  const AnalyticsFilterSheet({
    super.key,
    required this.initialDays,
    required this.initialPlatform,
  });

  @override
  State<AnalyticsFilterSheet> createState() => _AnalyticsFilterSheetState();
}

class _AnalyticsFilterSheetState extends State<AnalyticsFilterSheet> {
  late int _days = widget.initialDays;
  late String _platform = widget.initialPlatform;
  static const _periods = [7, 14, 30, 60, 90];
  static const _platformOptions = ['Instagram', 'Facebook'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),
            sheetHeading(context, 'Filter analitik', 'Sesuaikan periode dan platform.'),
            const SizedBox(height: 24),
            const Text('Rentang waktu'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _periods
                  .map(
                    (days) => optionPill(
                      label: '$days hari',
                      selected: _days == days,
                      onTap: () => setState(() => _days = days),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Text('Platform sosial media'),
            const SizedBox(height: 5),
            const Text(
              'Pilih satu platform.',
              style: TextStyle(color: AppColors.muted, fontSize: 13),
            ),
            const SizedBox(height: 12),
            Row(
              children: _platformOptions
                  .map(
                    (platform) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: platform == 'Instagram' ? 8 : 0,
                        ),
                        child: optionPill(
                          label: platform,
                          selected: _platform == platform,
                          onTap: () => setState(() => _platform = platform),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Divider(color: AppColors.border),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => setState(() {
                        _days = 7;
                        _platform = 'Instagram';
                      }),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.surfaceRaised,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text('Reset'),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, (
                        days: _days,
                        platform: _platform,
                      )),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13),
                        ),
                      ),
                      child: const Text('Terapkan filter'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CommentPlatformSheet extends StatefulWidget {
  final String? initialPlatform;

  const CommentPlatformSheet({super.key, required this.initialPlatform});

  @override
  State<CommentPlatformSheet> createState() => _CommentPlatformSheetState();
}

class _CommentPlatformSheetState extends State<CommentPlatformSheet> {
  late String _platform = widget.initialPlatform ?? 'All';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 18),
            sheetHeading(
              context,
              'Filter platform',
              'Pilih platform untuk menampilkan komentar.',
            ),
            const SizedBox(height: 20),
            for (final platform in ['All', 'Instagram', 'Facebook'])
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: optionPill(
                  label: platform == 'All' ? 'Semua' : platform,
                  selected: _platform == platform,
                  onTap: () => setState(() => _platform = platform),
                  expand: true,
                ),
              ),
            const SizedBox(height: 10),
            PrimaryButton(
              label: 'Terapkan filter',
              icon: Icons.check_rounded,
              onPressed: () => Navigator.pop(context, _platform),
            ),
          ],
        ),
      ),
    );
  }
}