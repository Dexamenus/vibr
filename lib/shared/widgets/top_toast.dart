import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

OverlayEntry? _currentToast;

/// Short message that slides in at the top of the screen and hides itself.
void showTopToast(
  BuildContext context, {
  required String message,
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

class _TopToast extends StatefulWidget {
  const _TopToast({
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
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
              child: GestureDetector(
                onTap: _dismiss,
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
                        Icon(widget.icon, color: widget.iconColor, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
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
      ),
    );
  }
}
