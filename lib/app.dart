import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/models/app_models.dart';
import 'core/state/app_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/create/create_screen.dart';
import 'features/posts/post_detail_screen.dart';
import 'features/schedule/schedule_screen.dart';

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
  int _selectedIndex = 1;
  int _scheduleVersion = 0;
  DateTime? _selectedScheduleDate;
  SocialPost? _editingPost;

  void _onNavigationSelected(int index) {
    if (index == 1 || index == 2) {
      setState(() => _selectedIndex = index);
      return;
    }

    const destinations = ['Beranda', 'Jadwal', 'Buat', 'Analitik', 'Profil'];
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${destinations[index]} segera hadir.')),
      );
  }

  void _onPostScheduled(DateTime dateTime) {
    setState(() {
      _selectedScheduleDate = dateTime;
      _scheduleVersion++;
      _selectedIndex = 1;
      _editingPost = null;
    });
  }

  void _onPostPublished(SocialPost post) {
    setState(() {
      _selectedScheduleDate = post.scheduledAt;
      _scheduleVersion++;
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
    if (_selectedIndex == 2) {
      return CreateScreen(
        key: ValueKey(_editingPost?.id ?? 'create'),
        controller: widget.controller,
        onNavigationSelected: _onNavigationSelected,
        onPostScheduled: _onPostScheduled,
        onPostPublished: _onPostPublished,
        onPostUpdated: _onPostUpdated,
        initialPost: _editingPost,
      );
    }

    return ScheduleScreen(
      key: ValueKey(_scheduleVersion),
      controller: widget.controller,
      initialSelectedDate: _selectedScheduleDate,
      onCreate: () => setState(() => _selectedIndex = 2),
      onPostTap: _openPostDetail,
      onPostEdit: _editPost,
      onNavigationSelected: _onNavigationSelected,
    );
  }
}
