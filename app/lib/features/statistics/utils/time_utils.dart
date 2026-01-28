import 'package:intl/intl.dart';

class TimeUtils {
  static String formatMinutes(double totalMinutes) {
    final int mins = totalMinutes.round();
    if (mins < 60) return '$mins min';

    final int hours = mins ~/ 60;
    final int remainingMins = mins % 60;
    final String hourLabel = hours == 1 ? 'hour' : 'hours';

    return remainingMins == 0
        ? '$hours $hourLabel'
        : '$hours $hourLabel $remainingMins min';
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime getStartOfWeek(int offset) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayMonday = today.subtract(Duration(days: now.weekday - 1));
    return todayMonday.subtract(Duration(days: 7 * offset));
  }

  static String formatDayLabel(DateTime date) {
    return DateFormat('E').format(date);
  }
}
