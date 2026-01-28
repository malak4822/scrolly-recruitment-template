import 'package:intl/intl.dart';

class FocusSessionService {
  static String getTodayKey() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static Map<String, int> addSessionToHistory({
    required Map<String, int> currentHistory,
    required int sessionSeconds,
    String? dateKey,
  }) {
    final newHistory = Map<String, int>.from(currentHistory);
    final key = dateKey ?? getTodayKey();
    final currentTotal = newHistory[key] ?? 0;
    newHistory[key] = currentTotal + sessionSeconds;
    return newHistory;
  }

  static Map<String, int> addMultipleSessionsToHistory({
    required Map<String, int> currentHistory,
    required Map<String, int> sessions,
  }) {
    final newHistory = Map<String, int>.from(currentHistory);
    sessions.forEach((key, seconds) {
      final currentTotal = newHistory[key] ?? 0;
      newHistory[key] = currentTotal + seconds;
    });
    return newHistory;
  }

  static Map<String, int> splitSessionByDays(DateTime start, DateTime end) {
    final Map<String, int> distribution = {};
    
    DateTime current = start;
    while (current.isBefore(end)) {
      final nextDay = DateTime(current.year, current.month, current.day + 1);
      final segmentEnd = nextDay.isBefore(end) ? nextDay : end;
      
      final duration = segmentEnd.difference(current);
      final seconds = duration.inSeconds;
      
      if (seconds > 0) {
        final key = DateFormat('yyyy-MM-dd').format(current);
        distribution[key] = (distribution[key] ?? 0) + seconds;
      }
      
      current = segmentEnd;
    }
    
    return distribution;
  }

  static Map<String, int> getCombinedHistory({
    required Map<String, int> focusHistory,
    required int currentSessionSeconds,
  }) {
    final history = Map<String, int>.from(focusHistory);
    final todayKey = getTodayKey();
    history[todayKey] = (history[todayKey] ?? 0) + currentSessionSeconds;
    return history;
  }
}
