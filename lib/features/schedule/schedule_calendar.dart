import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/app_models.dart';
import '../../core/theme/app_theme.dart';

class ScheduleCalendar extends StatelessWidget {
  const ScheduleCalendar({
    super.key,
    required this.displayedMonth,
    required this.selectedDay,
    required this.posts,
    required this.onDaySelected,
    required this.onMonthOffset,
    required this.onMonthSelected,
  });

  final DateTime displayedMonth;
  final DateTime selectedDay;
  final List<SocialPost> posts;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<int> onMonthOffset;
  final ValueChanged<DateTime> onMonthSelected;

  List<DateTime> get _calendarDays {
    final firstOfMonth = DateTime(displayedMonth.year, displayedMonth.month);
    final offset = firstOfMonth.weekday % 7;
    final dayCount = DateTime(
      displayedMonth.year,
      displayedMonth.month + 1,
      0,
    ).day;
    final rowCount = ((dayCount + offset) / 7).ceil();
    final firstCell = firstOfMonth.subtract(Duration(days: offset));
    return List.generate(
      rowCount * 7,
      (index) => firstCell.add(Duration(days: index)),
    );
  }

  Future<void> _showMonthPicker(BuildContext context) async {
    final selectedMonth = await showDialog<DateTime>(
      context: context,
      builder: (context) {
        var pickerYear = displayedMonth.year;

        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text(
              'Pilih bulan',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            content: SizedBox(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: pickerYear > 1
                            ? () => setDialogState(() => pickerYear--)
                            : null,
                        tooltip: 'Tahun sebelumnya',
                        icon: const Icon(Icons.chevron_left_rounded),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          key: const ValueKey('schedule-year-dropdown'),
                          value: pickerYear,
                          dropdownColor: AppColors.surfaceRaised,
                          borderRadius: BorderRadius.circular(12),
                          icon: const Icon(
                            Icons.arrow_drop_down_rounded,
                            color: AppColors.accent,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          items: [
                            for (
                              var year = pickerYear - 5 > 1
                                  ? pickerYear - 5
                                  : 1;
                              year <=
                                  (pickerYear + 5 < DateTime.now().year + 5
                                      ? pickerYear + 5
                                      : DateTime.now().year + 5);
                              year++
                            )
                              DropdownMenuItem(
                                value: year,
                                child: Text('$year'),
                              ),
                          ],
                          onChanged: (year) {
                            if (year != null) {
                              setDialogState(() => pickerYear = year);
                            }
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: pickerYear < DateTime.now().year + 5
                            ? () => setDialogState(() => pickerYear++)
                            : null,
                        tooltip: 'Tahun berikutnya',
                        icon: const Icon(Icons.chevron_right_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: 12,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 44,
                        ),
                    itemBuilder: (context, index) {
                      final month = index + 1;
                      final isSelected =
                          pickerYear == displayedMonth.year &&
                          month == displayedMonth.month;
                      return TextButton(
                        onPressed: () =>
                            Navigator.of(context)
                                .pop(DateTime(pickerYear, month)),
                        style: TextButton.styleFrom(
                          foregroundColor: isSelected
                              ? Colors.white
                              : AppColors.muted,
                          backgroundColor: isSelected
                              ? AppColors.accent
                              : Colors.transparent,
                        ),
                        child: Text(
                          DateFormat(
                            'MMM',
                            'id_ID',
                          ).format(DateTime(pickerYear, month)),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (selectedMonth != null && context.mounted) {
      onMonthSelected(selectedMonth);
    }
  }

  @override
  Widget build(BuildContext context) {
    const weekdays = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    final days = _calendarDays;
    final isAtMaximumMonth =
        displayedMonth.year >= DateTime.now().year + 5 &&
        displayedMonth.month == 12;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => onMonthOffset(-1),
              tooltip: 'Bulan sebelumnya',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.chevron_left_rounded, size: 22),
            ),
            TextButton(
              key: const ValueKey('month-year-picker'),
              onPressed: () => _showMonthPicker(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                visualDensity: VisualDensity.compact,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('MMMM yyyy', 'id_ID').format(displayedMonth),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down_rounded, size: 20),
                ],
              ),
            ),
            IconButton(
              onPressed: isAtMaximumMonth ? null : () => onMonthOffset(1),
              tooltip: 'Bulan berikutnya',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.chevron_right_rounded, size: 22),
            ),
          ],
        ),
        Row(
          children: [
            for (final weekday in weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    weekday,
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 38,
          ),
          itemBuilder: (context, index) {
            final day = days[index];
            final isSelected = DateUtils.isSameDay(day, selectedDay);
            final isInMonth = day.month == displayedMonth.month;
            final hasPosts = posts.any(
              (post) => DateUtils.isSameDay(post.scheduledAt, day),
            );
            final isToday = DateUtils.isSameDay(day, DateTime.now());
            return InkWell(
              onTap: day.year > DateTime.now().year + 5
                  ? null
                  : () => onDaySelected(day),
              customBorder: const CircleBorder(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent : Colors.transparent,
                      shape: BoxShape.circle,
                      border: isToday && !isSelected
                          ? Border.all(color: AppColors.accent, width: 1)
                          : null,
                    ),
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : isInMonth
                            ? Colors.white
                            : AppColors.muted.withValues(alpha: 0.45),
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (hasPosts && !isSelected)
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.teal,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    const SizedBox(height: 3),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
