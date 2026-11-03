import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';

class LineChartCard extends StatelessWidget {
  const LineChartCard({
    super.key,
    required this.values,
    required this.axisLabels,
    required this.xAxisLabels,
    this.maxValue = 6,
    this.chartColor = AppColors.accent,
  });

  final List<double> values;
  final List<String> axisLabels;
  final List<String> xAxisLabels;
  final double maxValue;
  final Color chartColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 7),
      child: Column(
        children: [
          SizedBox(
            height: 112,
            child: Row(
              children: [
                SizedBox(
                  width: 34,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: axisLabels
                        .map(
                          (label) => Text(
                            label,
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 10,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                Expanded(
                  child: CustomPaint(
                    painter: _LinePainter(
                      values: values,
                      maxValue: maxValue,
                      color: chartColor,
                    ),
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: xAxisLabels
                .map(
                  (label) => Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 10,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  const _LinePainter({
    required this.values,
    required this.maxValue,
    required this.color,
  });

  final List<double> values;
  final double maxValue;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const topInset = 7.0;
    const bottomInset = 4.0;
    final chartHeight = size.height - topInset - bottomInset;
    final gridPaint = Paint()
      ..color = AppColors.border.withValues(alpha: 0.75)
      ..strokeWidth = 1;

    for (final fraction in [0.0, 0.5, 1.0]) {
      final y = topInset + chartHeight * fraction;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (values.isEmpty) return;
    final safeMaxValue = maxValue <= 0 ? 1.0 : maxValue;
    final points = <Offset>[
      for (var index = 0; index < values.length; index++)
        Offset(
          values.length == 1
              ? size.width / 2
              : size.width * index / (values.length - 1),
          topInset +
              chartHeight * (1 - (values[index] / safeMaxValue).clamp(0, 1)),
        ),
    ];
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      line.lineTo(point.dx, point.dy);
    }

    final area = Path.from(line)
      ..lineTo(points.last.dx, size.height - bottomInset)
      ..lineTo(points.first.dx, size.height - bottomInset)
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..color = color.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke,
    );
    canvas.drawCircle(points.last, 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.maxValue != maxValue ||
      oldDelegate.color != color;
}
