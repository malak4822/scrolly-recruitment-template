import 'package:app/features/statistics/services/focus_session_service.dart';
import 'package:app/features/statistics/services/weekly_chart_data_service.dart';
import 'package:app/features/statistics/utils/focus_calculator.dart';
import 'package:app/features/statistics/data/models/weekly_chart_view_model.dart';
import 'package:equatable/equatable.dart';

class FocusStatsState extends Equatable {
  final bool isLoading;
  final bool isFocusing;
  final Map<String, int> focusHistory;
  final int currentSessionSeconds;
  final DateTime? sessionStartTime;

  const FocusStatsState({
    this.isLoading = true,
    this.isFocusing = false,
    this.focusHistory = const {},
    this.currentSessionSeconds = 0,
    this.sessionStartTime,
  });

  FocusStatsState copyWith({
    bool? isLoading,
    bool? isFocusing,
    Map<String, int>? focusHistory,
    int? currentSessionSeconds,
    DateTime? sessionStartTime,
  }) {
    return FocusStatsState(
      isLoading: isLoading ?? this.isLoading,
      isFocusing: isFocusing ?? this.isFocusing,
      focusHistory: focusHistory ?? this.focusHistory,
      currentSessionSeconds: currentSessionSeconds ?? this.currentSessionSeconds,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isFocusing,
    focusHistory,
    currentSessionSeconds,
    sessionStartTime,
  ];
}

extension FocusStatsStateX on FocusStatsState {
  Map<String, int> get combinedHistory {
    return FocusSessionService.getCombinedHistory(
      focusHistory: focusHistory,
      currentSessionSeconds: currentSessionSeconds,
    );
  }

  DateTime? get earliestDate {
    return FocusCalculator.findEarliestDate(focusHistory);
  }

  int get todayTotalSeconds {
    return FocusCalculator.getTodayTotalSeconds(
      history: focusHistory,
      currentSessionSeconds: currentSessionSeconds,
    );
  }

  int get currentStreak {
    return FocusCalculator.calculateStreak(combinedHistory);
  }

  int get totalDaysWithFocus {
    return FocusCalculator.calculateTotalDaysWithFocus(combinedHistory);
  }

  int get totalOverallSeconds {
    return FocusCalculator.calculateTotalSeconds(combinedHistory);
  }

  WeeklyChartViewModel getWeeklyChartData(
    int weekIndex,
    DateTime? selectedDate,
  ) {
    return WeeklyChartDataService.getWeeklyChartData(
      focusHistory: combinedHistory,
      weekIndex: weekIndex,
      selectedDate: selectedDate,
    );
  }

  int get weeklyChartPageCount {
    return WeeklyChartDataService.getWeeklyChartPageCount(
      focusHistory: focusHistory,
    );
  }
}
