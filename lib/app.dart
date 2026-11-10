import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/models/app_models.dart';
import 'core/state/app_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_flow.dart';
import 'features/create/create_screen.dart';
import 'features/home/home_screen.dart';
import 'features/insights/insights_screen.dart';
import 'features/posts/post_detail_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/schedule/schedule_screen.dart';
import 'shared/widgets/app_bottom_navigation.dart';

class VibrApp extends StatefulWidget {
  const VibrApp({super.key});

  @override
  State<VibrApp> createState() => _VibrAppState();
}

class _VibrAppState extends State<VibrApp> {
  late final AppController _controller = AppController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibr',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      locale: const Locale('id', 'ID'),
      supportedLocales: const [Locale('id', 'ID')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: AuthFlow(
        controller: _controller,
        appBuilder: (onSignOut) =>
            _VibrHome(controller: _controller, onSignOut: onSignOut),
      ),
    );
  }
}

class _VibrHome extends StatefulWidget {
  const _VibrHome({required this.controller, required this.onSignOut});

  final AppController controller;
  final Future<void> Function() onSignOut;

  @override
  State<_VibrHome> createState() => _VibrHomeState();
}

class _VibrHomeState extends State<_VibrHome> {
  int _selectedIndex = 0;
  int _scheduleVersion = 0;
  int _createVersion = 0;
  DateTime? _selectedScheduleDate;
  SocialPost? _editingPost;

  void _onNavigationSelected(int index) {
    if (index < 0 || index > 4 || index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
      if (index != 2) _editingPost = null;
    });
  }

  void _openCreate() {
    setState(() {
      _editingPost = null;
      _selectedIndex = 2;
    });
  }

  void _onPostScheduled(DateTime dateTime) {
    setState(() {
      _selectedScheduleDate = dateTime;
      _scheduleVersion++;
      _createVersion++;
      _selectedIndex = 1;
      _editingPost = null;
    });
  }

  void _onPostPublished(SocialPost post) {
    setState(() {
      _selectedScheduleDate = post.scheduledAt;
      _scheduleVersion++;
      _createVersion++;
      _selectedIndex = 1;
      _editingPost = null;
    });
    _openPostDetail(post);
  }

  void _editPost(SocialPost post) {
    setState(() {
      _editingPost = post;
      _selectedIndex = 2;
    });
  }

  void _onPostUpdated(DateTime dateTime) {
    setState(() {
      _selectedScheduleDate = dateTime;
      _scheduleVersion++;
      _createVersion++;
      _selectedIndex = 1;
      _editingPost = null;
    });
  }

  void _openPostDetail(SocialPost post) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => PostDetailScreen(post: post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
            showBottomNavigation: false,
            onNavigationSelected: _onNavigationSelected,
            onOpenSchedule: () => _onNavigationSelected(1),
          ),
          ScheduleScreen(
            key: ValueKey(_scheduleVersion),
            controller: widget.controller,
            initialSelectedDate: _selectedScheduleDate,
            onCreate: _openCreate,
            onPostTap: _openPostDetail,
            onPostEdit: _editPost,
            onNavigationSelected: _onNavigationSelected,
            showBottomNavigation: false,
          ),
          CreateScreen(
            key: ValueKey('${_editingPost?.id ?? 'create'}-$_createVersion'),
            controller: widget.controller,
            onNavigationSelected: _onNavigationSelected,
            onPostScheduled: _onPostScheduled,
            onPostPublished: _onPostPublished,
            onPostUpdated: _onPostUpdated,
            initialPost: _editingPost,
            showBottomNavigation: false,
          ),
          const InsightsScreen(),
          ProfileScreen(
            onBack: () => _onNavigationSelected(0),
            onSignOut: widget.onSignOut,
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomNavigation(
          selectedIndex: _selectedIndex,
          onSelected: _onNavigationSelected,
        ),
      ),
    );
  }
}
