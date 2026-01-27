import 'package:app/constants/app_color.dart';
import 'package:app/constants/app_fonts.dart';
import 'package:app/constants/app_shadows.dart';
import 'package:app/features/statistics/cubit/focus_stats_cubit.dart';
import 'package:app/features/statistics/cubit/focus_stats_state.dart';
import 'package:app/features/statistics/widgets/weekly_chart/components/chart_header.dart';
import 'package:app/features/statistics/widgets/weekly_chart/components/weekly_chart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class WeeklyChartWidget extends StatefulWidget {
  const WeeklyChartWidget({super.key});

  @override
  State<WeeklyChartWidget> createState() => _WeeklyChartWidgetState();
}

class _WeeklyChartWidgetState extends State<WeeklyChartWidget> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FocusStatsCubit, FocusStatsState>(
      builder: (context, state) {
        final cubit = context.read<FocusStatsCubit>();
        int itemCount = 1;
        final earliest = cubit.earliestDate;

        if (earliest != null) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final currentMonday = today.subtract(Duration(days: now.weekday - 1));

          final earliestMonday = DateTime(
            earliest.year,
            earliest.month,
            earliest.day,
          ).subtract(Duration(days: earliest.weekday - 1));

          final diffDays = currentMonday.difference(earliestMonday).inDays;
          if (diffDays >= 0) {
            itemCount = (diffDays / 7).floor() + 1;
          }
        }

        return Container(
          width: 348.w,
          height: 328.h,
          padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 30.h),
          decoration: BoxDecoration(
            color: AppColor.card,
            borderRadius: BorderRadius.circular(47.r),
            boxShadow: AppShadows.defaultShadow,
          ),
          child: PageView.builder(
            itemCount: itemCount,
            reverse: true, // Index 0 is Current Week
            physics: const BouncingScrollPhysics(),
            onPageChanged: (_) => setState(() {
              _selectedDate = null;
            }),
            itemBuilder: (context, index) => _buildWeekPage(context, index),
          ),
        );
      },
    );
  }

  Widget _buildWeekPage(BuildContext context, int weekIndex) {
    final weekData = _getWeekData(context, weekIndex);

    double totalMinutes = 0;
    if (weekData.isNotEmpty) {
      totalMinutes = weekData
          .map((e) => e['minutes'] as double)
          .reduce((a, b) => a + b);
    }

    final historyValues = context
        .read<FocusStatsCubit>()
        .state
        .focusHistory
        .values;
    final double globalMaxSeconds = historyValues.isNotEmpty
        ? historyValues.reduce((a, b) => a > b ? a : b).toDouble()
        : 0;

    double maxMinutes = globalMaxSeconds / 60.0;
    if (maxMinutes < 1) maxMinutes = 1.0;

    final double avgMinutes = weekData.isNotEmpty
        ? totalMinutes / weekData.length
        : 0;
    final double safeMax = maxMinutes;

    String topLabel = 'Average focus time';
    String mainValueText = _formatMinutes(avgMinutes);
    if (_selectedDate != null) {
      final selection = weekData.firstWhere(
        (e) => _isSameDay(e['date'] as DateTime, _selectedDate!),
        orElse: () => {},
      );
      if (selection.isNotEmpty) {
        topLabel = 'Focus time';
        mainValueText = _formatMinutes(selection['minutes'] as double);
      }
    }

    String subHeader;
    if (weekIndex == 0) {
      if (_selectedDate != null) {
        subHeader = DateFormat('EEEE').format(_selectedDate!);
      } else {
          subHeader = 'This week';
      }
    } else if (weekIndex == 1) {
      if (_selectedDate != null) {
        subHeader = 'Last ${DateFormat('EEEE').format(_selectedDate!)}';
      } else {
        subHeader = 'Last week';
      }
    } else {
      final start = _getStartOfWeek(weekIndex);
      final end = start.add(const Duration(days: 6));
      final fmtStart = DateFormat('MMM d').format(start);
      final fmtEnd = DateFormat('MMM d').format(end);
      subHeader = '$fmtStart - $fmtEnd';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChartHeader(
          topLabel: topLabel,
          mainValueText: mainValueText,
          subHeader: subHeader,
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: WeeklyChartView(
            weekData: weekData,
            selectedDate: _selectedDate,
            avgMinutes: avgMinutes,
            safeMax: safeMax,
            onDateSelect: (date) => setState(() {
              if (_selectedDate != null && _isSameDay(_selectedDate!, date)) {
                _selectedDate = null;
              } else {
                _selectedDate = date;
              }
            }),
          ),
        ),
      ],
    );
  }

  List<Map<String, dynamic>> _getWeekData(BuildContext context, int weekIndex) {
    final cubit = context.read<FocusStatsCubit>();
    final startMonday = _getStartOfWeek(weekIndex);
    final List<Map<String, dynamic>> data = [];

    for (int i = 0; i < 7; i++) {
      final date = startMonday.add(Duration(days: i));
      final seconds = cubit.getStatsForDate(date);
      if (seconds > 0) {
        data.add({
          'date': date,
          'dayLabel': DateFormat('E').format(date),
          'minutes': seconds / 60.0,
        });
      }
    }
    return data;
  }

  DateTime _getStartOfWeek(int offset) {
    final now = DateTime.now();
    // Normalize to midnight to avoid time issues
    final today = DateTime(now.year, now.month, now.day);
    // Find Monday of current week
    final todayMonday = today.subtract(Duration(days: now.weekday - 1));
    return todayMonday.subtract(Duration(days: 7 * offset));
  }

  String _formatMinutes(double totalMinutes) {
    final int mins = totalMinutes.round();
    if (mins < 60) return '$mins min';

    final int hours = mins ~/ 60;
    final int remainingMins = mins % 60;
    final String hourLabel = hours == 1 ? 'hour' : 'hours';

    return remainingMins == 0
        ? '$hours $hourLabel'
        : '$hours $hourLabel $remainingMins min';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
