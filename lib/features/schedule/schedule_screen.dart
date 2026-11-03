import 'package:flutter/material.dart';

import '../../core/models/app_models.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_icon_button.dart';
import '../../shared/widgets/app_page.dart';
import '../../shared/widgets/empty_state.dart';
import '../../shared/widgets/generated_artwork.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/screen_header.dart';
import '../../shared/widgets/section_heading.dart';
import '../../shared/widgets/social_platform_icon.dart';
import '../../shared/widgets/status_pill.dart';
import '../../shared/widgets/surface_card.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({
    super.key,
    required this.controller,
    required this.onOpenCreate,
    required this.onOpenPost,
  });

  final AppController controller;
  final VoidCallback onOpenCreate;
  final ValueChanged<SocialPost> onOpenPost;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _month = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _weekView = false;

  void _changeMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
      if (_selectedDate.month != _month.month ||
          _selectedDate.year != _month.year) {
        _selectedDate = DateTime(_month.year, _month.month, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ScreenHeader(
            title: 'Schedule',
            trailing: AppIconButton(
              icon: Icons.add,
              filled: true,
              tooltip: 'Create a post',
              onPressed: widget.onOpenCreate,
            ),
          ),
          SurfaceCard(
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: _ViewToggle(
                    label: 'Month',
                    selected: !_weekView,
                    onTap: () => setState(() => _weekView = false),
                  ),
                ),
                Expanded(
                  child: _ViewToggle(
                    label: 'Week',
                    selected: _weekView,
                    onTap: () => setState(() => _weekView = true),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${_monthLabel(_month.month)} ${_month.year}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                tooltip: 'Previous month',
                onPressed: () => _changeMonth(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              IconButton(
                tooltip: 'Next month',
                onPressed: () => _changeMonth(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 6),
          if (_weekView)
            _WeekCalendar(
              month: _month,
              selectedDate: _selectedDate,
              posts: widget.controller.posts,
              onSelected: (date) => setState(() => _selectedDate = date),
            )
          else
            _MonthCalendar(
              month: _month,
              selectedDate: _selectedDate,
              posts: widget.controller.posts,
              onSelected: (date) => setState(() {
                _selectedDate = date;
                _month = DateTime(date.year, date.month);
              }),
            ),
          const SizedBox(height: 20),
          SectionHeading(
            title:
                '${_weekdayLabel(_selectedDate.weekday)}, ${_monthLabel(_selectedDate.month)} ${_selectedDate.day}',
            padding: const EdgeInsets.only(bottom: 12),
          ),
          AnimatedBuilder(
            animation: widget.controller,
            builder: (context, _) {
              final posts = widget.controller.postsOn(_selectedDate);
              if (posts.isEmpty) {
                return EmptyState(
                  icon: Icons.event_available_outlined,
                  title: 'A little room for your next idea',
                  message: 'There are no posts planned for this day yet.',
                  action: PrimaryButton(
                    label: 'Schedule your first post',
                    icon: Icons.add,
                    onPressed: widget.onOpenCreate,
                  ),
                );
              }
              return Column(
                children: [
                  for (final post in posts) ...[
                    _ScheduledPostTile(
                      post: post,
                      onTap: () => widget.onOpenPost(post),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.surfaceRaised : Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.muted,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({
    required this.month,
    required this.selectedDate,
    required this.posts,
    required this.onSelected,
  });

  final DateTime month;
  final DateTime selectedDate;
  final List<SocialPost> posts;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    final offset = firstOfMonth.weekday - 1;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final cells = ((offset + daysInMonth + 6) ~/ 7) * 7;
    final postDays = posts
        .where(
          (post) =>
              post.scheduledAt.year == month.year &&
              post.scheduledAt.month == month.month,
        )
        .map((post) => post.scheduledAt.day)
        .toSet();

    return Column(
      children: [
        const Row(
          children: [
            _WeekdayCell('M'),
            _WeekdayCell('T'),
            _WeekdayCell('W'),
            _WeekdayCell('T'),
            _WeekdayCell('F'),
            _WeekdayCell('S'),
            _WeekdayCell('S'),
          ],
        ),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cells,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 46,
          ),
          itemBuilder: (context, index) {
            final day = index - offset + 1;
            if (day < 1 || day > daysInMonth) {
              final adjacent = day < 1
                  ? DateTime(month.year, month.month, day)
                  : DateTime(month.year, month.month + 1, day - daysInMonth);
              return _CalendarDay(
                date: adjacent,
                selected: false,
                hasPost: false,
                muted: true,
                onTap: () => onSelected(adjacent),
              );
            }
            final date = DateTime(month.year, month.month, day);
            return _CalendarDay(
              date: date,
              selected: _sameDay(date, selectedDate),
              hasPost: postDays.contains(day),
              onTap: () => onSelected(date),
            );
          },
        ),
      ],
    );
  }
}

class _WeekCalendar extends StatelessWidget {
  const _WeekCalendar({
    required this.month,
    required this.selectedDate,
    required this.posts,
    required this.onSelected,
  });

  final DateTime month;
  final DateTime selectedDate;
  final List<SocialPost> posts;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final monday = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    return Row(
      children: [
        for (var index = 0; index < 7; index++)
          Expanded(
            child: _CalendarDay(
              date: monday.add(Duration(days: index)),
              selected: _sameDay(
                monday.add(Duration(days: index)),
                selectedDate,
              ),
              hasPost: posts.any(
                (post) => _sameDay(
                  post.scheduledAt,
                  monday.add(Duration(days: index)),
                ),
              ),
              onTap: () => onSelected(monday.add(Duration(days: index))),
            ),
          ),
      ],
    );
  }
}

class _WeekdayCell extends StatelessWidget {
  const _WeekdayCell(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.muted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.date,
    required this.selected,
    required this.hasPost,
    required this.onTap,
    this.muted = false,
  });

  final DateTime date;
  final bool selected;
  final bool hasPost;
  final bool muted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.accent : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${date.day}',
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : muted
                    ? AppColors.muted.withValues(alpha: 0.45)
                    : Colors.white,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            height: 4,
            child: hasPost
                ? const DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.teal,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(width: 4, height: 4),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}

class _ScheduledPostTile extends StatelessWidget {
  const _ScheduledPostTile({required this.post, required this.onTap});

  final SocialPost post;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final time =
        '${post.scheduledAt.hour.toString().padLeft(2, '0')}:${post.scheduledAt.minute.toString().padLeft(2, '0')}';
    return SurfaceCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: GeneratedArtwork(height: 60, seed: post.id.hashCode),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SocialPlatformIcon(platform: post.platform),
                    const SizedBox(width: 6),
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
                ),
                const SizedBox(height: 4),
                Text(
                  '$time · ${post.format}',
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

bool _sameDay(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;

String _weekdayLabel(int weekday) => const [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
][weekday - 1];

String _monthLabel(int month) => const [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
][month - 1];
