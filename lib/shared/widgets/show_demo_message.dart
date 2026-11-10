import 'package:flutter/material.dart';

import 'top_toast.dart';

void showDemoMessage(BuildContext context, String message) {
  showTopToast(
    context,
    title: 'Informasi',
    message: message,
    icon: Icons.info_outline_rounded,
    iconColor: const Color(0xFF8A78FF),
  );
}
