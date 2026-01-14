import 'dart:ui';

import 'package:dana_bozzetto/moduls/calender/controller/calendar_controller.dart';
import 'package:dana_bozzetto/moduls/calender/model/calendar_day_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CalendarScreen extends StatefulWidget {
  final DateTime? initialMonth;
  final DateTime? initialSelectedDate;
  final ValueChanged<DateTime>? onMonthChanged;
  final ValueChanged<DateTime>? onDateSelected;
  final bool showCalendarCard;

  const CalendarScreen({
    super.key,
    this.initialMonth,
    this.initialSelectedDate,
    this.onMonthChanged,
    this.onDateSelected,
    this.showCalendarCard = true,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final CalendarController _controller;
  late DateTime _focusedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(CalendarController());
    final now = DateTime.now();
    final initialMonth = widget.initialMonth ?? now;
    final initialDate = widget.initialSelectedDate ?? now;
    _focusedMonth = DateTime(initialMonth.year, initialMonth.month, 1);
    _selectedDate = DateTime(initialDate.year, initialDate.month, initialDate.day);
  }

  @override
  void didUpdateWidget(covariant CalendarScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final incomingMonth = widget.initialMonth;
    if (incomingMonth != null &&
        (incomingMonth.year != _focusedMonth.year ||
            incomingMonth.month != _focusedMonth.month)) {
      _focusedMonth = DateTime(incomingMonth.year, incomingMonth.month, 1);
    }
    final incomingDate = widget.initialSelectedDate;
    if (incomingDate != null &&
        (incomingDate.year != _selectedDate.year ||
            incomingDate.month != _selectedDate.month ||
            incomingDate.day != _selectedDate.day)) {
      _selectedDate = DateTime(
        incomingDate.year,
        incomingDate.month,
        incomingDate.day,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Obx(() {
        final days = _controller.calendarDays;
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 12),
          children: [
            if (widget.showCalendarCard) ...[
              _calendarCard(),
              const SizedBox(height: 16),
            ],
            ...days.map((item) => CalendarRow(item: item)),
          ],
        );
      }),
    );
  }

  Widget _calendarCard() {
    final monthTitle = _monthTitle(_focusedMonth);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _pickMonthYear,
                      child: Text(
                        monthTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      color: Colors.white,
                      onPressed: _goToPreviousMonth,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      color: Colors.white,
                      onPressed: _goToNextMonth,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _weekdaysRow(),
                const SizedBox(height: 8),
                _daysGrid(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _weekdaysRow() {
    const labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return Row(
      children: List.generate(labels.length, (index) {
        final isSunday = index == 0;
        return Expanded(
          child: Center(
            child: Text(
              labels[index],
              style: TextStyle(
                color: isSunday ? const Color(0xFFFF3B30) : Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _daysGrid() {
    final year = _focusedMonth.year;
    final month = _focusedMonth.month;
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    final firstWeekday = DateTime(year, month, 1).weekday;
    final leadingEmpty = firstWeekday % 7;
    const totalCells = 42;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalCells,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (context, index) {
        final dayNumber = index - leadingEmpty + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }
        final isSunday = index % 7 == 0;
        final isSelected = _selectedDate.year == year &&
            _selectedDate.month == month &&
            _selectedDate.day == dayNumber;
        final textColor = isSunday
            ? const Color(0xFFFF3B30)
            : Colors.white;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = DateTime(year, month, dayNumber);
            });
            widget.onDateSelected?.call(_selectedDate);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF0C7A7E) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                dayNumber.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
      _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    });
    widget.onMonthChanged?.call(_focusedMonth);
    widget.onDateSelected?.call(_selectedDate);
  }

  void _goToNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
      _selectedDate = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    });
    widget.onMonthChanged?.call(_focusedMonth);
    widget.onDateSelected?.call(_selectedDate);
  }

  Future<void> _pickMonthYear() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0C7A7E),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked == null) return;
    setState(() {
      _focusedMonth = DateTime(picked.year, picked.month, 1);
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
    });
    widget.onMonthChanged?.call(_focusedMonth);
    widget.onDateSelected?.call(_selectedDate);
  }

  String _monthTitle(DateTime date) {
    const months = [
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
    ];
    final monthName = months[date.month - 1];
    return '$monthName ${date.year}';
  }
}

/// ===============================
/// CALENDAR ROW
/// ===============================
class CalendarRow extends StatelessWidget {
  final CalendarDayModel item;

  const CalendarRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DATE COLUMN
          SizedBox(
            width: 52,
            child: Column(
              children: [
                Text(
                  item.day,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.date.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// TASK OR EMPTY
          Expanded(
            child: item.task == null
                ? const SizedBox(height: 58) // BLANK DAY
                : Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title ?? "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.task!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
