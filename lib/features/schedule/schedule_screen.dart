import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/app_models.dart';
import '../../core/state/app_controller.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_bottom_navigation.dart';
import '../../shared/widgets/show_demo_message.dart';
import 'schedule_calendar.dart';
import 'schedule_empty_state.dart';
import 'schedule_post_tile.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({
    super.key,
    required this.controller,
    required this.onCreate,
    required this.onPostTap,
    required this.onPostEdit,
    required this.onNavigationSelected,
    this.initialSelectedDate,
    this.showBottomNavigation = true,
  });

  final AppController controller;
  final VoidCallback onCreate;
  final ValueChanged<SocialPost> onPostTap;
  final ValueChanged<SocialPost> onPostEdit;
  final ValueChanged<int> onNavigationSelected;
  final DateTime? initialSelectedDate;
  final bool showBottomNavigation;

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late DateTime _selectedDay;
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    final scheduledPosts = widget.controller.posts.where(
      (post) => post.status == PostStatus.scheduled,
    );
    _selectedDay = _dateOnly(
      widget.initialSelectedDate ??
          (scheduledPosts.isEmpty ? today : scheduledPosts.first.scheduledAt),
    );
    _displayedMonth = DateTime(_selectedDay.year, _selectedDay.month);
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _selectDay(DateTime day) {
    setState(() {
      _selectedDay = _dateOnly(day);
      _displayedMonth = DateTime(day.year, day.month);
    });
  }

  void _changeMonth(int offset) {
    final month = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + offset,
    );
    if (month.year > DateTime.now().year + 5) return;
    _selectMonth(month);
  }

  void _selectMonth(DateTime month) {
    final lastDay = DateTime(month.year, month.month + 1, 0).day;
    final day = _selectedDay.day > lastDay ? lastDay : _selectedDay.day;
    setState(() {
      _displayedMonth = DateTime(month.year, month.month);
      _selectedDay = DateTime(month.year, month.month, day);
    });
  }

  List<SocialPost> get _calendarPosts => widget.controller.posts;

  @override
  Widget build(BuildContext context) {
    final selectedPosts = widget.controller.postsOn(_selectedDay);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 14),
              ScheduleCalendar(
                displayedMonth: _displayedMonth,
                selectedDay: _selectedDay,
                posts: _calendarPosts,
                onDaySelected: _selectDay,
                onMonthOffset: _changeMonth,
                onMonthSelected: _selectMonth,
              ),
              const SizedBox(height: 20),
              _buildSelectedDayHeader(selectedPosts.length),
              const SizedBox(height: 12),
              if (selectedPosts.isEmpty)
                ScheduleEmptyState(onCreate: widget.onCreate)
              else
                ...selectedPosts.map(
                  (post) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SchedulePostTile(
                      post: post,
                      onTap: () => widget.onPostTap(post),
                      onMenuAction: (action) => _handlePostAction(post, action),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.showBottomNavigation
          ? SafeArea(
              top: false,
              child: AppBottomNavigation(
                selectedIndex: 1,
                onSelected: widget.onNavigationSelected,
              ),
            )
          : null,
    );
  }

  Future<void> _handlePostAction(
    SocialPost post,
    SchedulePostAction action,
  ) async {
    switch (action) {
      case SchedulePostAction.details:
        widget.onPostTap(post);
      case SchedulePostAction.edit:
        widget.onPostEdit(post);
      case SchedulePostAction.delete:
        final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text('Hapus postingan?'),
            content: const Text('Postingan ini akan dihapus dari jadwal.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Hapus',
                  style: TextStyle(color: AppColors.red),
                ),
              ),
            ],
          ),
        );
        if (shouldDelete == true) {
          widget.controller.deletePost(post.id);
          if (mounted) {
            showDemoMessage(context, 'Postingan dihapus dari jadwal.');
          }
        }
    }
  }

  Widget _buildHeader() {
    return Row(
      children: [
        const Expanded(
          child: Text(
            'Jadwal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
            ),
          ),
        ),
        IconButton(
          onPressed: widget.onCreate,
          tooltip: 'Tambah postingan terjadwal',
          style: IconButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            fixedSize: const Size(36, 36),
            padding: EdgeInsets.zero,
          ),
          icon: const Icon(Icons.add_rounded, size: 22),
        ),
      ],
    );
  }

  Widget _buildSelectedDayHeader(int postCount) {
    return Row(
      children: [
        Expanded(
          child: Text(
            DateFormat('EEEE, d MMMM', 'id_ID').format(_selectedDay),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          '$postCount Postingan',
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    );
  }
}
