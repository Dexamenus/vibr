import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'insights_models.dart';
import 'widgets/custom_tab_bar.dart';
import 'tabs/overview_tab.dart';
import 'tabs/comments_tab.dart';

enum InsightsTab { overview, comments }

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key, this.initialComments});

  final List<InsightsComment>? initialComments;

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  InsightsTab _tab = InsightsTab.overview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: _buildInsights(),
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
              CustomTabBar(
                selectedTab: _tab,
                onTabChanged: (newTab) => setState(() => _tab = newTab),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _tab == InsightsTab.overview
              ? const OverviewTab()
              : CommentsTab(initialComments: widget.initialComments),
        ),
      ],
    );
  }
}