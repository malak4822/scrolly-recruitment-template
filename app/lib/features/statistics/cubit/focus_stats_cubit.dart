import 'dart:async';
import 'package:app/features/statistics/data/repositories/statistics_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'focus_stats_state.dart';

class FocusStatsCubit extends Cubit<FocusStatsState> {
  final StatisticsRepository _repository;
  Timer? _timer;

  // Fake data toggle
  FocusStatsCubit({StatisticsRepository? repository})
    : _repository = repository ?? StatisticsRepository(useFakeData: kDebugMode),
      super(const FocusStatsState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final history = await _repository.loadData();
    emit(state.copyWith(isLoading: false, focusHistory: history));
  }

  // --- Core Focus Logic ---

  void toggleFocus() {
    if (state.isFocusing) {
      _stopFocusSession();
    } else {
      _startFocusSession();
    }
  }

  void _startFocusSession() {
    emit(state.copyWith(isFocusing: true, currentSessionSeconds: 0));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      emit(
        state.copyWith(currentSessionSeconds: state.currentSessionSeconds + 1),
      );
    });
  }

  Future<void> _stopFocusSession() async {
    _timer?.cancel();

    final sessionSeconds = state.currentSessionSeconds;
    final Map<String, int> newHistory = Map<String, int>.from(
      state.focusHistory,
    );
    final String todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final currentTotal = newHistory[todayKey] ?? 0;
    newHistory[todayKey] = currentTotal + sessionSeconds;

    // Optimistic update
    emit(
      state.copyWith(
        isFocusing: false,
        currentSessionSeconds: 0,
        focusHistory: newHistory,
      ),
    );

    // Persist
    await _repository.saveData(newHistory);
  }

  // --- Public API for UI ---

  // Get formatted daily stats for a specific date
  int getStatsForDate(DateTime date) {
    final key = DateFormat('yyyy-MM-dd').format(date);
    return state.focusHistory[key] ?? 0;
  }

  /// Returns the earliest date present in the history, or null if empty.
  DateTime? get earliestDate {
    if (state.focusHistory.isEmpty) return null;

    DateTime? min;
    for (final key in state.focusHistory.keys) {
      try {
        final date = DateFormat('yyyy-MM-dd').parse(key);
        if (min == null || date.isBefore(min)) {
          min = date;
        }
      } catch (_) {
        // Ignore parse errors
      }
    }
    return min;
  }

  // Helper for "Today" including current session
  int get todayTotalSeconds {
    final key = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final historySeconds = state.focusHistory[key] ?? 0;
    return historySeconds + state.currentSessionSeconds;
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
