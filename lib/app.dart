import 'package:flutter/material.dart';

import 'core/state/app_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_screens.dart';

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
      title: 'SociAI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: SignInScreen(controller: _controller),
    );
  }
}
