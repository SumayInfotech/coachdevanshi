import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/utils.dart';
import '../../../../main.dart';
import '../../../widgets/common_text.dart';

class DayRhythmModel {
  final String dayName;
  final String dateNumber;
  final bool isCompleted;
  final bool isActive;

  const DayRhythmModel({
    required this.dayName,
    required this.dateNumber,
    this.isCompleted = false,
    this.isActive = false,
  });
}

class WeeklyRhythmStrip extends StatefulWidget {
  final String? monthYearText;
  final List<DayRhythmModel>? days;
  final Function(int index)? onDaySelected;

  const WeeklyRhythmStrip({
    super.key,
    this.monthYearText,
    this.days,
    this.onDaySelected,
  });

  @override
  State<WeeklyRhythmStrip> createState() => _WeeklyRhythmStripState();
}

class _WeeklyRhythmStripState extends State<WeeklyRhythmStrip> {
  int _selectedIndex = 0;
  late List<DayRhythmModel> _dayList;
  late String _monthYearDisplay;

  @override
  void initState() {
    super.initState();
    if (widget.days != null && widget.days!.isNotEmpty) {
      _dayList = widget.days!;
      _selectedIndex = _dayList.indexWhere((d) => d.isActive);
      if (_selectedIndex == -1) _selectedIndex = 0;
      _monthYearDisplay = widget.monthYearText ?? DateFormat('MMMM yyyy').format(DateTime.now());
    } else {
      _generateCurrentWeek();
    }
  }

  void _generateCurrentWeek() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday; // 1 = Monday, 7 = Sunday
    DateTime startOfWeek = now.subtract(Duration(days: currentWeekday - 1));

    _dayList = [];
    _selectedIndex = -1;

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      
      bool isToday = day.year == now.year && day.month == now.month && day.day == now.day;
      bool isPast = day.isBefore(DateTime(now.year, now.month, now.day));

      _dayList.add(DayRhythmModel(
        dayName: DateFormat('EEE').format(day).toUpperCase(),
        dateNumber: DateFormat('d').format(day),
        isCompleted: isPast,
        isActive: isToday,
      ));

      if (isToday) {
        _selectedIndex = i;
      }
    }

    if (_selectedIndex == -1) _selectedIndex = 0;
    _monthYearDisplay = widget.monthYearText ?? DateFormat('MMMM yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_outlined,
                    size: 18,
                    color: appColors.primary,
                  ),
                  const SizedBox(width: 8),
                  const CommonText(
                    "Weekly Rhythm",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1B1A),
                    ),
                    fontFamily: 'serif',
                  ),
                ],
              ),
              CommonText(
                _monthYearDisplay,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF534343),
                ),
                fontFamily: fontFamilyPlusJakartaSans,
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 7-Day Strip
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_dayList.length, (index) {
              final day = _dayList[index];
              final isSelected = index == _selectedIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                    if (widget.onDaySelected != null) {
                      widget.onDaySelected!(index);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? appColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: appColors.primary.withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      children: [
                        CommonText(
                          day.dayName,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.85)
                                : const Color(0xFF534343),
                          ),
                          fontFamily: fontFamilyPlusJakartaSans,
                        ),
                        const SizedBox(height: 4),
                        CommonText(
                          day.dateNumber,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                            color: isSelected ? Colors.white : const Color(0xFF1D1B1A),
                          ),
                          fontFamily: fontFamilyPlusJakartaSans,
                        ),
                        const SizedBox(height: 6),
                        // Bottom dot indicator
                        Container(
                          width: 5,
                          height: 5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Colors.white
                                : (day.isCompleted
                                    ? appColors.primary.withValues(alpha: 0.6)
                                    : const Color(0xFFE7E1DF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
