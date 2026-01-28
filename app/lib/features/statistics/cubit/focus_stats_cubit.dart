import 'dart:async';
import 'package:app/features/statistics/data/repositories/statistics_repository.dart';
import 'package:app/features/statistics/services/focus_session_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'focus_stats_state.dart';

class FocusStatsCubit extends Cubit<FocusStatsState> {
  final StatisticsRepository _repository;
  Timer? _timer;

  FocusStatsCubit()
    : _repository = StatisticsRepository(),
      super(const FocusStatsState()) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final history = await _repository.loadData();
    emit(state.copyWith(isLoading: false, focusHistory: history));
    await _recoverSession();
  }

  void toggleFocus() {
    if (state.isFocusing) {
      _stopFocusSession();
    } else {
      _startFocusSession();
    }
  }

  void _startFocusSession({bool isRecovery = false}) {
    if (!isRecovery) {
      final now = DateTime.now();
      emit(state.copyWith(
        isFocusing: true,
        currentSessionSeconds: 0,
        sessionStartTime: now,
      ));
      _repository.saveFocusState(isFocusing: true, startTime: now);
    } else {
      emit(state.copyWith(isFocusing: true));
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final startTime = state.sessionStartTime;
      if (startTime == null) return;

      final now = DateTime.now();
      final todayKey = FocusSessionService.getTodayKey();
      final sessionStartKey = FocusSessionService.splitSessionByDays(startTime, startTime.add(const Duration(seconds: 1))).keys.first;
      
      if (todayKey != sessionStartKey) {
        await _saveCurrentFocus();
        return; 
      }

      final diff = now.difference(startTime).inSeconds;
      emit(state.copyWith(currentSessionSeconds: diff));
    });
  }

  Future<void> _stopFocusSession() async {
    _timer?.cancel();

    final now = DateTime.now();
    final effectiveStartTime = state.sessionStartTime ?? now.subtract(Duration(seconds: state.currentSessionSeconds));
    
    final distribution = FocusSessionService.splitSessionByDays(effectiveStartTime, now);
    final newHistory = FocusSessionService.addMultipleSessionsToHistory(
      currentHistory: state.focusHistory,
      sessions: distribution,
    );

    emit(
      state.copyWith(
        isFocusing: false,
        currentSessionSeconds: 0,
        sessionStartTime: null,
        focusHistory: newHistory,
      ),
    );

    await _repository.saveFocusState(isFocusing: false);
    await _repository.saveData(newHistory);
  }

  Future<void> _saveCurrentFocus() async {
    if (!state.isFocusing) return;

    final startTime = state.sessionStartTime;
    if (startTime == null) return;

    final now = DateTime.now();
    final distribution = FocusSessionService.splitSessionByDays(startTime, now);
    final todayKey = FocusSessionService.getTodayKey();
    
    final pastSessions = Map<String, int>.from(distribution)..remove(todayKey);
    
    if (pastSessions.isNotEmpty) {
      final newHistory = FocusSessionService.addMultipleSessionsToHistory(
        currentHistory: state.focusHistory,
        sessions: pastSessions,
      );
      
      final todayStart = DateTime(now.year, now.month, now.day);
      emit(state.copyWith(
        focusHistory: newHistory,
        sessionStartTime: todayStart,
      ));
      
      await _repository.saveData(newHistory);
      await _repository.saveFocusState(isFocusing: true, startTime: todayStart);
    }
  }

  Future<void> _recoverSession() async {
    final (isFocusingStored, startTime) = await _repository.getFocusState();
    if (!isFocusingStored || startTime == null) return;

    final now = DateTime.now();
    if (now.isBefore(startTime)) return;

    final distribution = FocusSessionService.splitSessionByDays(startTime, now);
    final todayKey = FocusSessionService.getTodayKey();
    
    final pastSessions = Map<String, int>.from(distribution)..remove(todayKey);
    Map<String, int> currentHistory = state.focusHistory;

    DateTime effectiveStartTime = startTime;
    if (pastSessions.isNotEmpty) {
      currentHistory = FocusSessionService.addMultipleSessionsToHistory(
        currentHistory: state.focusHistory,
        sessions: pastSessions,
      );
      await _repository.saveData(currentHistory);
      
      effectiveStartTime = DateTime(now.year, now.month, now.day);
      await _repository.saveFocusState(isFocusing: true, startTime: effectiveStartTime);
    }

    final todaySeconds = distribution[todayKey] ?? 0;
    emit(state.copyWith(
      focusHistory: currentHistory,
      isFocusing: true,
      currentSessionSeconds: todaySeconds,
      sessionStartTime: effectiveStartTime,
    ));

    _startFocusSession(isRecovery: true);
  }

  void saveOnAppPause() => _saveCurrentFocus();

  @override
  Future<void> close() async {
    _timer?.cancel();
    await _saveCurrentFocus();
    return super.close();
  }
}
