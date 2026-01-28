import 'package:app/features/statistics/utils/focus_calculator.dart';
import 'package:app/features/statistics/utils/time_utils.dart';
import 'package:app/features/statistics/data/models/weekly_chart_view_model.dart';
import 'package:intl/intl.dart';

class WeeklyChartDataService {
  static WeeklyChartViewModel getWeeklyChartData({
    required Map<String, int> focusHistory,
    required int weekIndex,
    DateTime? selectedDate,
  }) {
    final weekDataList = _getWeekDataForChart(
      focusHistory: focusHistory,
      weekIndex: weekIndex,
    );

    double totalMinutes = 0;
    if (weekDataList.isNotEmpty) {
      totalMinutes = weekDataList.map((e) => e.minutes).reduce((a, b) => a + b);
    }

    final historyValues = focusHistory.values;
    final double globalMaxSeconds = historyValues.isNotEmpty
        ? historyValues.reduce((a, b) => a > b ? a : b).toDouble()
        : 0;

    double maxMinutes = globalMaxSeconds / 60.0;
    if (maxMinutes < 1) maxMinutes = 1.0;

    final double avgMinutes =
        weekDataList.isNotEmpty ? totalMinutes / weekDataList.length : 0;

    String topLabel = 'Average focus time';
    String mainValueText = TimeUtils.formatMinutes(avgMinutes);

    if (selectedDate != null) {
      final selection = weekDataList.where(
        (e) => TimeUtils.isSameDay(e.date, selectedDate),
      );

      if (selection.isNotEmpty) {
        topLabel = 'Focus time';
        mainValueText = TimeUtils.formatMinutes(selection.first.minutes);
      }
    }

    String subHeader;
    if (weekIndex == 0) {
      if (selectedDate != null) {
        subHeader = DateFormat('EEEE').format(selectedDate);
      } else {
        subHeader = 'This week';
      }
    } else if (weekIndex == 1) {
      if (selectedDate != null) {
        subHeader = 'Last ${DateFormat('EEEE').format(selectedDate)}';
      } else {
        subHeader = 'Last week';
      }
    } else {
      final start = TimeUtils.getStartOfWeek(weekIndex);
      final end = start.add(const Duration(days: 6));
      final fmtStart = DateFormat('MMM d').format(start);
      final fmtEnd = DateFormat('MMM d').format(end);
      subHeader = '$fmtStart - $fmtEnd';
    }

    return WeeklyChartViewModel(
      weekData: weekDataList,
      selectedDate: selectedDate,
      avgMinutes: avgMinutes,
      safeMax: maxMinutes,
      topLabel: topLabel,
      mainValueText: mainValueText,
      subHeader: subHeader,
    );
  }

  static List<WeeklyChartBarData> _getWeekDataForChart({
    required Map<String, int> focusHistory,
    required int weekIndex,
  }) {
    final startMonday = TimeUtils.getStartOfWeek(weekIndex);
    final List<WeeklyChartBarData> data = [];

    for (int i = 0; i < 7; i++) {
      final date = startMonday.add(Duration(days: i));
      final seconds = _getStatsForDate(focusHistory, date);
      if (seconds > 0) {
        data.add(WeeklyChartBarData(
          date: date,
          dayLabel: TimeUtils.formatDayLabel(date),
          minutes: seconds / 60.0,
        ));
      }
    }
    return data;
  }

  static int _getStatsForDate(Map<String, int> history, DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    return history[key] ?? 0;
  }

  static int getWeeklyChartPageCount({
    required Map<String, int> focusHistory,
  }) {
    int itemCount = 1;
    final earliest = FocusCalculator.findEarliestDate(focusHistory);

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

    return itemCount;
  }
}
