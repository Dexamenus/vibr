import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/models/app_models.dart';
import 'core/state/app_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/create/create_screen.dart';
import 'features/home/home_screen.dart';
import 'features/posts/post_detail_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/schedule/schedule_screen.dart';
import 'shared/widgets/app_bottom_navigation.dart';

class SociAiApp extends StatefulWidget {
  const SociAiApp({super.key});

  @override
  State<SociAiApp> createState() => _SociAiAppState();
}

class _SociAiAppState extends State<SociAiApp> {
  late final AppController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AppController();
  }

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
      home: _SociAiHome(controller: _controller),
    );
  }
}

class _SociAiHome extends StatefulWidget {
  const _SociAiHome({required this.controller});

  final AppController controller;

  @override
  State<_SociAiHome> createState() => _SociAiHomeState();
}

class _SociAiHomeState extends State<_SociAiHome> {
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
          const _InsightsScreen(),
          ProfileScreen(onBack: () => _onNavigationSelected(0)),
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

class _InsightsScreen extends StatelessWidget {
  const _InsightsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.insights_rounded, size: 40, color: AppColors.accent),
              const SizedBox(height: 12),
              Text(
                'Insight',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Analitik akan segera hadir.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
