import 'package:intl/intl.dart';

class FocusCalculator {
  static String formatTodayTime(int totalSeconds, {bool showSeconds = true}) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (showSeconds) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else {
      return '${hours}h ${minutes}m';
    }
  }

  static String calculateOverallTime(int totalSeconds) {
    if (totalSeconds <= 0) return '0d 0h 0m';

    final days = totalSeconds ~/ (24 * 3600);
    final remainingAfterDays = totalSeconds % (24 * 3600);
    final hours = remainingAfterDays ~/ 3600;
    final remainingAfterHours = remainingAfterDays % 3600;
    final minutes = remainingAfterHours ~/ 60;

    return '${days}d ${hours}h ${minutes}m';
  }

  static int calculateStreak(Map<String, int> history) {
    if (history.isEmpty) return 0;

    final today = DateTime.now();
    final todayStr = _dateToString(today);
    final yesterdayStr = _dateToString(today.subtract(const Duration(days: 1)));

    int streak = 0;
    
    String? currentCheck;
    
    
    if (history.containsKey(todayStr) && (history[todayStr] ?? 0) >= 60) {
      currentCheck = todayStr;
    } else if (history.containsKey(yesterdayStr) && (history[yesterdayStr] ?? 0) >= 60) {
      currentCheck = yesterdayStr;
    } else {
      return 0;
    }

    while (currentCheck != null) {
      if (history.containsKey(currentCheck) && (history[currentCheck] ?? 0) >= 60) {
        streak++; 
        final currentDate = DateTime.parse(currentCheck);
        final prevDate = currentDate.subtract(const Duration(days: 1));
        currentCheck = _dateToString(prevDate);
      } else {
        break;
      }
    }
    
    return streak;
  }

  static String _dateToString(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  static int calculateTotalDaysWithFocus(
    Map<String, int> history, {
    int minSecondsForDay = 60,
  }) {
    return history.values.where((v) => v >= minSecondsForDay).length;
  }

  static int calculateTotalSeconds(Map<String, int> history) {
    return history.values.fold(0, (sum, val) => sum + val);
  }

  static DateTime? findEarliestDate(Map<String, int> history) {
    if (history.isEmpty) return null;

    DateTime? min;
    for (final key in history.keys) {
      try {
        final date = DateFormat('yyyy-MM-dd').parse(key);
        if (min == null || date.isBefore(min)) {
          min = date;
        }
      } catch (_) {}
    }
    return min;
  }

  static int getTodayTotalSeconds({
    required Map<String, int> history,
    required int currentSessionSeconds,
  }) {
    final todayKey = _dateToString(DateTime.now());
    final historySeconds = history[todayKey] ?? 0;
    return historySeconds + currentSessionSeconds;
  }
}
