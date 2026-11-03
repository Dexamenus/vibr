import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class GeneratedArtwork extends StatelessWidget {
  const GeneratedArtwork({super.key, this.height = 190, this.seed = 0});

  final double height;
  final int seed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(
          painter: _ArtworkPainter(seed),
          child: Center(
            child: Container(
              width: height * 0.27,
              height: height * 0.27,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [
                    Color(0xFFF7E8FF),
                    Color(0xFFB88BFF),
                    Color(0xFF6534D1),
                  ],
                  stops: [0, 0.32, 1],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.8),
                    blurRadius: 35,
                    spreadRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArtworkPainter extends CustomPainter {
  const _ArtworkPainter(this.seed);

  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final background = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF242139), Color(0xFF111119), Color(0xFF29203D)],
      ).createShader(rect);
    canvas.drawRect(rect, background);

    final center = Offset(size.width * 0.53, size.height * 0.53);
    final rotation = seed * 0.22;
    for (var index = 0; index < 3; index++) {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(rotation + index * 0.83);
      final path = Path()
        ..addOval(
          Rect.fromCenter(
            center: Offset.zero,
            width: size.width * (0.83 - index * 0.12),
            height: size.height * (0.34 - index * 0.035),
          ),
        );
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9 - index * 2
        ..shader =
            LinearGradient(
              colors: [
                const Color(0xFF6937CF).withValues(alpha: 0.35),
                const Color(0xFFD6C5FF),
                const Color(0xFF8F56FF),
                const Color(0xFF21143D),
              ],
            ).createShader(
              Rect.fromCenter(
                center: Offset.zero,
                width: size.width,
                height: size.height,
              ),
            );
      canvas.drawPath(path, paint);
      canvas.restore();
    }

    final sparklePaint = Paint()..color = AppColors.teal;
    canvas.drawCircle(
      Offset(size.width * 0.77, size.height * 0.32),
      4,
      sparklePaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.71),
      2.5,
      Paint()..color = const Color(0xFFE7D6FF),
    );
  }

  @override
  bool shouldRepaint(_ArtworkPainter oldDelegate) => oldDelegate.seed != seed;
}
