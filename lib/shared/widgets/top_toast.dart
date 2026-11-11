import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

OverlayEntry? _currentToast;

/// Short message that slides in at the top of the screen and hides itself.
void showTopToast(
  BuildContext context, {
  required String message,
  String? title,
  IconData icon = Icons.check_circle_outline_rounded,
  Color iconColor = AppColors.teal,
  Duration duration = const Duration(seconds: 3),
}) {
  _currentToast?.remove();

  final overlay = Overlay.of(context, rootOverlay: true);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _TopToast(
      message: message,
      title: title ?? _titleForColor(iconColor),
      icon: icon,
      iconColor: iconColor,
      duration: duration,
      onDismissed: () {
        entry.remove();
        if (_currentToast == entry) _currentToast = null;
      },
    ),
  );
  _currentToast = entry;
  overlay.insert(entry);
}

String _titleForColor(Color color) {
  if (color == AppColors.teal) return 'Berhasil';
  if (color == AppColors.red) return 'Terjadi kesalahan';
  if (color == AppColors.amber) return 'Perlu perhatian';
  return 'Informasi';
}

class _TopToast extends StatefulWidget {
  const _TopToast({
    required this.message,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final String title;
  final IconData icon;
  final Color iconColor;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_TopToast> createState() => _TopToastState();
}

class _TopToastState extends State<_TopToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    _timer?.cancel();
    if (!mounted) return;
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Positioned(
      top: top + 12,
      left: 24,
      right: 24,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: FadeTransition(
            opacity: _curve,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -0.6),
                end: Offset.zero,
              ).animate(_curve),
              child: Material(
                color: AppColors.surfaceRaised,
                elevation: 8,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: widget.iconColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.iconColor,
                          size: 17,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.message,
                              style: const TextStyle(
                                color: AppColors.muted,
                                fontSize: 11,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        key: const ValueKey('dismiss-feedback-toast'),
                        borderRadius: BorderRadius.circular(20),
                        onTap: _dismiss,
                        child: const Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.muted,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
