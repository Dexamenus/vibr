import 'package:flutter/material.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({
    super.key,
    required this.label,
    this.color,
    this.backgroundColor,
  });

  final String label;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final resolvedColor = color ?? Theme.of(context).colorScheme.primary;
    final resolvedBackgroundColor =
        backgroundColor ?? resolvedColor.withValues(alpha: 0.12);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolvedBackgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: TextStyle(
            color: resolvedColor,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
