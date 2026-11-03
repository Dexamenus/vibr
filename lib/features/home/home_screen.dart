import 'package:flutter/material.dart';

import '../../core/models/app_models.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_page.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/generated_artwork.dart';
import '../../shared/widgets/metric_card.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/section_heading.dart';
import '../../shared/widgets/social_platform_icon.dart';
import '../../shared/widgets/status_pill.dart';
import '../../shared/widgets/surface_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.controller,
    required this.onOpenSchedule,
    required this.onOpenCreate,
    required this.onOpenComments,
    required this.onOpenInsights,
    required this.onOpenProfile,
    required this.onOpenPost,
  });

  final AppController controller;
  final VoidCallback onOpenSchedule;
  final VoidCallback onOpenCreate;
  final VoidCallback onOpenComments;
  final VoidCallback onOpenInsights;
  final VoidCallback onOpenProfile;
  final ValueChanged<SocialPost> onOpenPost;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return AppPage(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_greeting(now.hour)},',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${controller.brandName.split(' ').first} ✨',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_weekdayName(now.weekday)}, ${_monthName(now.month)} ${now.day}, ${now.year} · Demo data',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: onOpenProfile,
                borderRadius: BorderRadius.circular(30),
                child: const CircleAvatar(
                  radius: 25,
                  backgroundColor: AppColors.surfaceRaised,
                  child: Text(
                    'ZN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MetricCard(
                icon: Icons.calendar_month_outlined,
                value: '12',
                label: 'Scheduled posts',
              ),
              SizedBox(width: 9),
              MetricCard(
                icon: Icons.insights_outlined,
                value: '+8.3%',
                label: 'Engagement rate',
                tint: AppColors.teal,
              ),
              SizedBox(width: 9),
              MetricCard(
                icon: Icons.chat_bubble_outline_rounded,
                value: '24',
                label: 'New comments',
              ),
            ],
          ),
          const SizedBox(height: 25),
          SectionHeading(
            title: "Today's Schedule",
            actionLabel: 'See all',
            onAction: onOpenSchedule,
          ),
          AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final posts = controller
                  .postsOn(DateTime.now())
                  .where((post) => post.status == PostStatus.scheduled)
                  .take(2)
                  .toList();
              if (posts.isEmpty) {
                return EmptyState(
                  title: 'Nothing scheduled yet',
                  message: 'Create a post and make room for a new idea.',
                  icon: Icons.calendar_today_outlined,
                  action: PrimaryButton(
                    label: 'Create a post',
                    onPressed: onOpenCreate,
                    icon: Icons.add,
                  ),
                );
              }
              return Column(
                children: [
                  for (var index = 0; index < posts.length; index++) ...[
                    _UpcomingPostTile(
                      post: posts[index],
                      seed: index,
                      onTap: () => onOpenPost(posts[index]),
                    ),
                    if (index != posts.length - 1) const SizedBox(height: 10),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          SurfaceCard(
            color: AppColors.accentSoft,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.accent),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Suggestions · Demo',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Your audience is most active at 6 PM.',
                        style: TextStyle(color: AppColors.muted, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'View comments',
                  onPressed: onOpenComments,
                  color: AppColors.accent,
                  icon: const Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SectionHeading(
            title: 'Recent Performance',
            actionLabel: 'Insights',
            onAction: onOpenInsights,
          ),
          const SurfaceCard(
            padding: EdgeInsets.fromLTRB(16, 15, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '+12.4%',
                      style: TextStyle(
                        color: AppColors.teal,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'vs. previous week',
                      style: TextStyle(color: AppColors.muted, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(height: 110, child: _PerformanceChart()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Mon', style: TextStyle(color: AppColors.muted)),
                    Text('Tue', style: TextStyle(color: AppColors.muted)),
                    Text('Wed', style: TextStyle(color: AppColors.muted)),
                    Text('Thu', style: TextStyle(color: AppColors.muted)),
                    Text('Fri', style: TextStyle(color: AppColors.muted)),
                    Text('Sat', style: TextStyle(color: AppColors.muted)),
                    Text('Sun', style: TextStyle(color: AppColors.muted)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            label: 'Create with AI',
            onPressed: onOpenCreate,
            icon: Icons.auto_awesome,
          ),
        ],
      ),
    );
  }
}

class _UpcomingPostTile extends StatelessWidget {
  const _UpcomingPostTile({
    required this.post,
    required this.seed,
    required this.onTap,
  });

  final SocialPost post;
  final int seed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(11),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: GeneratedArtwork(height: 58, seed: seed),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SocialPlatformIcon(platform: post.platform, size: 15),
                    const SizedBox(width: 5),
                    Text(
                      post.platform,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    StatusPill(status: post.status),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  post.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_shortDate(post.scheduledAt)} · ${_formatTime(post.scheduledAt)}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _shortDate(DateTime date) => '${_monthName(date.month)} ${date.day}';

String _formatTime(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _monthName(int month) => const [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
][month - 1];

String _weekdayName(int weekday) => const [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
][weekday - 1];

String _greeting(int hour) {
  if (hour < 12) return 'Good morning';
  if (hour < 17) return 'Good afternoon';
  return 'Good evening';
}

class _PerformanceChart extends StatelessWidget {
  const _PerformanceChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _PerformanceChartPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _PerformanceChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    for (var row = 1; row <= 3; row++) {
      final y = size.height * row / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    const values = [0.72, 0.62, 0.69, 0.43, 0.49, 0.31, 0.38, 0.21, 0.28];
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

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.teal.withValues(alpha: 0.18),
            AppColors.teal.withValues(alpha: 0.01),
          ],
        ).createShader(Offset.zero & size),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.teal
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_PerformanceChartPainter oldDelegate) => false;
}
