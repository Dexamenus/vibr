import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_bottom_navigation.dart';
import '../../shared/widgets/line_chart_card.dart';
import '../../shared/widgets/metric_card.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/section_heading.dart';
import '../../shared/widgets/selectable_pill.dart';
import 'insights_demo_data.dart';
import 'insights_models.dart';

part 'overview/overview.dart';
part 'comments/comments.dart';

enum _InsightsTab { overview, comments }

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key, this.initialComments});

  final List<InsightsComment>? initialComments;

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  _InsightsTab _tab = _InsightsTab.overview;
  int _periodDays = 7;
  String _platform = 'Instagram';
  String _contentType = 'Reels';
  String? _commentPlatform;
  String _commentFilter = 'Semua';
  int _navigationIndex = 3;
  late List<InsightsComment> _comments;
  final Map<String, String> _replies = {};

  void _updateState(VoidCallback update) => setState(update);

  @override
  void initState() {
    super.initState();
    _comments = [...(widget.initialComments ?? InsightsDemoData.comments)];
  }

  @override
  Widget build(BuildContext context) {
    final isInsights = _navigationIndex == 3;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: isInsights ? _buildInsights() : _buildOtherTab(),
      ),
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: _navigationIndex,
        onSelected: (index) {
          setState(() {
            _navigationIndex = index;
            if (index == 3) _tab = _InsightsTab.overview;
          });
        },
      ),
    );
  }

  Widget _buildInsights() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Wawasan',
                  style: Theme.of(context).textTheme.titleLarge
                      ?.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 16),
              _buildTabSwitch(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: IndexedStack(
            index: _tab == _InsightsTab.overview ? 0 : 1,
            children: [_buildOverview(), _buildComments()],
          ),
        ),
      ],
    );
  }

  Widget _buildTabSwitch() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _tabItem(
            label: 'Ringkasan',
            icon: Icons.trending_up_rounded,
            selected: _tab == _InsightsTab.overview,
            onTap: () => setState(() => _tab = _InsightsTab.overview),
          ),
          _tabItem(
            label: 'Komentar',
            icon: Icons.chat_bubble_outline,
            selected: _tab == _InsightsTab.comments,
            onTap: () => setState(() => _tab = _InsightsTab.comments),
          ),
        ],
      ),
    );
  }

  Widget _tabItem({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
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

  Widget _filterButton({required VoidCallback onTap}) {
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

  Widget _buildOtherTab() {
    const labels = ['Beranda', 'Jadwal', 'Buat', 'Wawasan', 'Profil'];
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labels[_navigationIndex],
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text('Layar demo', style: TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}

Widget _sheetHeading(String title, String subtitle) {
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
      Builder(
        builder: (context) => IconButton(
          onPressed: () => Navigator.pop(context),
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.cancel_outlined, size: 20),
        ),
      ),
    ],
  );
}

Widget _optionPill({
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
        mainAxisAlignment: expand
            ? MainAxisAlignment.start
            : MainAxisAlignment.center,
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
