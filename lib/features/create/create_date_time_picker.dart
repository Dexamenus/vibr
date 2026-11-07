part of 'create_screen.dart';

class _DateTimePickerDialog extends StatefulWidget {
  const _DateTimePickerDialog({required this.initialDateTime});

  final DateTime initialDateTime;

  @override
  State<_DateTimePickerDialog> createState() => _DateTimePickerDialogState();
}

class _DateTimePickerDialogState extends State<_DateTimePickerDialog> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  late int _hour;
  late int _minute;

  DateTime get _today => DateUtils.dateOnly(DateTime.now());
  int get _maximumYear => DateTime.now().year + 5;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialDateTime;
    _selectedDate = DateUtils.dateOnly(initial);
    _displayedMonth = DateTime(initial.year, initial.month);
    _hour = initial.hour;
    _minute = initial.minute;
  }

  List<DateTime> get _days {
    final firstOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month);
    final offset = firstOfMonth.weekday % 7;
    final numberOfDays = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + 1,
      0,
    ).day;
    final rowCount = ((numberOfDays + offset) / 7).ceil();
    final firstDay = firstOfMonth.subtract(Duration(days: offset));
    return List.generate(
      rowCount * 7,
      (index) => firstDay.add(Duration(days: index)),
    );
  }

  bool get _canGoToPreviousMonth {
    final firstAllowed = DateTime(_today.year, _today.month);
    return DateTime(
          _displayedMonth.year,
          _displayedMonth.month - 1,
        ).compareTo(firstAllowed) >=
        0;
  }

  bool get _canGoToNextMonth =>
      _displayedMonth.year < _maximumYear ||
      (_displayedMonth.year == _maximumYear && _displayedMonth.month < 12);

  void _changeMonth(int delta) {
    if ((delta < 0 && !_canGoToPreviousMonth) ||
        (delta > 0 && !_canGoToNextMonth)) {
      return;
    }
    final nextMonth = DateTime(
      _displayedMonth.year,
      _displayedMonth.month + delta,
    );
    setState(() {
      _displayedMonth = nextMonth;
      final lastDay = DateTime(nextMonth.year, nextMonth.month + 1, 0).day;
      final day = _selectedDate.day.clamp(1, lastDay);
      _selectedDate = DateTime(nextMonth.year, nextMonth.month, day);
      if (_selectedDate.isBefore(_today)) _selectedDate = _today;
    });
  }

  void _changeYear(int delta) {
    final year = _displayedMonth.year + delta;
    if (year < _today.year || year > _maximumYear) return;
    setState(() {
      _displayedMonth = DateTime(year, _displayedMonth.month);
      final lastDay = DateTime(year, _displayedMonth.month + 1, 0).day;
      final day = _selectedDate.day.clamp(1, lastDay);
      _selectedDate = DateTime(year, _displayedMonth.month, day);
      if (_selectedDate.isBefore(_today)) _selectedDate = _today;
    });
  }

  void _changeHour(int delta) {
    setState(() {
      _hour = (_hour + delta) % 24;
      if (_hour < 0) _hour += 24;
    });
  }

  void _changeMinute(int delta) {
    setState(() {
      final nextMinute = _minute + delta * 5;
      if (nextMinute >= 60) {
        _minute = 0;
      } else if (nextMinute < 0) {
        _minute = 55;
      } else {
        _minute = nextMinute;
      }
    });
  }

  void _confirm() {
    Navigator.pop(
      context,
      DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _hour,
        _minute,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tanggal & waktu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Tutup',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.close_rounded, size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 7, child: _buildDatePicker()),
                  Container(
                    width: 1,
                    height: 250,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: AppColors.border,
                  ),
                  Expanded(flex: 4, child: _buildTimePicker()),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PrimaryButton(
                      key: const ValueKey('confirm-date-time'),
                      label: 'Selesai',
                      onPressed: _confirm,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    const weekdays = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];
    final days = _days;
    final isCurrentYear = _displayedMonth.year == _today.year;
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Tanggal',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: _canGoToPreviousMonth ? () => _changeMonth(-1) : null,
              tooltip: 'Bulan sebelumnya',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.chevron_left_rounded, size: 18),
            ),
            Expanded(
              child: Text(
                DateFormat('MMM', 'id_ID').format(_displayedMonth),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: _canGoToNextMonth ? () => _changeMonth(1) : null,
              tooltip: 'Bulan berikutnya',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.chevron_right_rounded, size: 18),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: isCurrentYear ? null : () => _changeYear(-1),
              tooltip: 'Tahun sebelumnya',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.remove_rounded, size: 15),
            ),
            Text(
              '${_displayedMonth.year}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              onPressed: _displayedMonth.year >= _maximumYear
                  ? null
                  : () => _changeYear(1),
              tooltip: 'Tahun berikutnya',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.add_rounded, size: 15),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            for (final weekday in weekdays)
              Expanded(
                child: Center(
                  child: Text(
                    weekday,
                    style: const TextStyle(color: AppColors.muted, fontSize: 9),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 3),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: days.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 27,
          ),
          itemBuilder: (context, index) {
            final day = days[index];
            final disabled =
                day.isBefore(_today) ||
                day.year > _maximumYear ||
                day.month != _displayedMonth.month;
            final selected = DateUtils.isSameDay(day, _selectedDate);
            return Center(
              child: InkWell(
                onTap: disabled
                    ? null
                    : () => setState(() => _selectedDate = day),
                customBorder: const CircleBorder(),
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.accent : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      color: selected
                          ? Colors.white
                          : disabled
                          ? AppColors.muted.withValues(alpha: 0.35)
                          : Colors.white,
                      fontSize: 10,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimePicker() {
    return Column(
      children: [
        const SizedBox(height: 12),
        const Text(
          'Waktu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TimeColumn(
              value: _hour.toString().padLeft(2, '0'),
              onIncrement: () => _changeHour(1),
              onDecrement: () => _changeHour(-1),
              tooltip: 'Jam',
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 2),
              child: Text(
                ':',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            _TimeColumn(
              value: _minute.toString().padLeft(2, '0'),
              onIncrement: () => _changeMinute(1),
              onDecrement: () => _changeMinute(-1),
              tooltip: 'Menit',
            ),
          ],
        ),
      ],
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
    required this.tooltip,
  });

  final String value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: onIncrement,
          tooltip: 'Tambah $tooltip',
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.keyboard_arrow_up_rounded, size: 18),
        ),
        Container(
          width: 34,
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        IconButton(
          onPressed: onDecrement,
          tooltip: 'Kurangi $tooltip',
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ),
      ],
    );
  }
}
