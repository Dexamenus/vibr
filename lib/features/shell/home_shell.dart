import 'package:flutter/material.dart';

import '../../core/models/app_models.dart';
import '../../core/state/app_controller.dart';
import '../../shared/widgets/app_widgets.dart';
import '../auth/auth_screens.dart';
import '../create/create_hub_screen.dart';
import '../create/prompt_input_screen.dart';
import '../home/home_screen.dart';
import '../insights/insights_screen.dart';
import '../posts/post_detail_screen.dart';
import '../schedule/schedule_screen.dart';
import '../settings/settings_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.controller});

  final AppController controller;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;
  final _insightsKey = GlobalKey<InsightsScreenState>();

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  void _openComments() {
    _selectTab(3);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _insightsKey.currentState?.showComments();
    });
  }

  void _openPrompt(String creationType) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PromptInputScreen(
          creationType: creationType,
          controller: widget.controller,
          onScheduled: () => _selectTab(1),
        ),
      ),
    );
  }

  void _openPost(SocialPost post) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PostDetailScreen(
          controller: widget.controller,
          post: post,
          onChanged: () => _selectTab(1),
          onOpenComments: _openComments,
        ),
      ),
    );
  }

  void _signOut() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => SignInScreen(controller: widget.controller),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) => IndexedStack(
          index: _selectedIndex,
          children: [
            HomeScreen(
              controller: widget.controller,
              onOpenSchedule: () => _selectTab(1),
              onOpenCreate: () => _selectTab(2),
              onOpenComments: _openComments,
              onOpenInsights: () => _selectTab(3),
              onOpenProfile: () => _selectTab(4),
              onOpenPost: _openPost,
            ),
            ScheduleScreen(
              controller: widget.controller,
              onOpenCreate: () => _openPrompt('Image + caption'),
              onOpenPost: _openPost,
            ),
            CreateHubScreen(
              onClose: () => _selectTab(0),
              onOpenPrompt: _openPrompt,
            ),
            InsightsScreen(key: _insightsKey, controller: widget.controller),
            SettingsScreen(controller: widget.controller, onSignOut: _signOut),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        selectedIndex: _selectedIndex,
        onSelected: _selectTab,
      ),
    );
  }
}
