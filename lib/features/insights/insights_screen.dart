import 'package:flutter/material.dart';

import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_widgets.dart';
import '../comments/comments_screen.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key, required this.controller});

  final AppController controller;

  @override
  InsightsScreenState createState() => InsightsScreenState();
}

class InsightsScreenState extends State<InsightsScreen> {
  String _range = 'Oct 20–26, 2026';
  bool _showComments = false;

  void showComments() {
    setState(() => _showComments = true);
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScreenHeader(
            title: 'Insights',
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _range,
                icon: const Icon(Icons.keyboard_arrow_down),
                dropdownColor: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                style: const TextStyle(color: Colors.white, fontSize: 12),
                items:
                    const ['Oct 20–26, 2026', 'Oct 13–19, 2026', 'Last 30 days']
                        .map(
                          (range) => DropdownMenuItem(
                            value: range,
                            child: Text(range),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _range = value);
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.insights_outlined),
                  label: Text('Overview'),
                ),
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.forum_outlined),
                  label: Text('Comments'),
                ),
              ],
              selected: {_showComments},
              showSelectedIcon: false,
              onSelectionChanged: (selection) =>
                  setState(() => _showComments = selection.first),
            ),
          ),
          if (_showComments)
            CommentsScreen(controller: widget.controller, embedded: true)
          else ...[
            const Row(
              children: [
                Expanded(
                  child: Text(
                    'Demo analytics · Instagram & Facebook',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
                Text('WIB', style: TextStyle(color: AppColors.muted)),
              ],
            ),
            const SizedBox(height: 17),
            const Row(
              children: [
                MetricCard(
                  value: '18,420',
                  label: 'Total reach',
                  caption: '↑ 12.4% vs prior 7D',
                ),
                SizedBox(width: 10),
                MetricCard(
                  value: '8.3%',
                  label: 'Engagement rate',
                  caption: '↑ 0.6 pp vs prior 7D',
                  tint: AppColors.teal,
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Row(
              children: [
                MetricCard(
                  value: '+128',
                  label: 'Followers',
                  caption: '↑ 4.2% this week',
                ),
                SizedBox(width: 10),
                MetricCard(
                  value: '9:00 AM',
                  label: 'Best time to post',
                  tint: AppColors.accent,
                ),
              ],
            ),
            const SizedBox(height: 23),
            const SectionHeading(title: 'Engagement over time'),
            SurfaceCard(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      _LegendDot(color: AppColors.accent, label: 'Engagement'),
                      SizedBox(width: 16),
                      _LegendDot(color: AppColors.teal, label: 'Reach'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const SizedBox(height: 165, child: _InsightsChart()),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (final day in [
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                        'Sun',
                      ])
                        Text(
                          day,
                          style: const TextStyle(
                            color: AppColors.muted,
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 23),
            const SectionHeading(title: 'Top posts'),
            AnimatedBuilder(
              animation: widget.controller,
              builder: (context, _) {
                final posts = widget.controller.posts.take(2).toList();
                return Column(
                  children: [
                    for (var index = 0; index < posts.length; index++) ...[
                      _TopPostTile(
                        caption: posts[index].caption,
                        platform: posts[index].platform,
                        index: index,
                      ),
                      const SizedBox(height: 10),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            SurfaceCard(
              color: AppColors.accentSoft,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.auto_awesome, color: AppColors.accent),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI insight · Demo',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Your visual posts get 2.4× more saves. Try sharing another carousel this week.',
                          style: TextStyle(color: AppColors.muted, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    );
  }
}

class _TopPostTile extends StatelessWidget {
  const _TopPostTile({
    required this.caption,
    required this.platform,
    required this.index,
  });

  final String caption;
  final String platform;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(11),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: GeneratedArtwork(height: 56, seed: index + 1),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  caption,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    SocialPlatformIcon(platform: platform, size: 14),
                    const SizedBox(width: 5),
                    Text(
                      platform,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            index == 0 ? '4.8%' : '3.9%',
            style: const TextStyle(
              color: AppColors.teal,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightsChart extends StatelessWidget {
  const _InsightsChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _InsightsChartPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _InsightsChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final grid = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (var row = 1; row < 4; row++) {
      final y = size.height * row / 4;
      canvas.drawLine(Offset.zero.translate(0, y), Offset(size.width, y), grid);
    }

    _drawSeries(canvas, size, const [
      0.76,
      0.55,
      0.62,
      0.43,
      0.50,
      0.32,
      0.39,
    ], AppColors.accent);
    _drawSeries(canvas, size, const [
      0.59,
      0.67,
      0.49,
      0.60,
      0.45,
      0.52,
      0.36,
    ], AppColors.teal);
  }

  void _drawSeries(Canvas canvas, Size size, List<double> values, Color color) {
    final path = Path();
    for (var index = 0; index < values.length; index++) {
      final point = Offset(
        size.width * index / (values.length - 1),
        size.height * values[index],
      );
      if (index == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_InsightsChartPainter oldDelegate) => false;
}
