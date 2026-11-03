import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/insights/insights_screen.dart';

class VibrApp extends StatelessWidget {
  const VibrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vibr',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      home: const InsightsScreen(),
    );
  }
}
