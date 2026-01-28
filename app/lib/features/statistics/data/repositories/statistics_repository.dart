import 'package:app/constants/app_developer_config.dart';
import 'package:app/features/statistics/data/fake_data_gen.dart';
import 'package:app/features/statistics/services/focus_storage_service.dart';

class StatisticsRepository {
  final FocusStorageService _service;

  StatisticsRepository() : _service = FocusStorageService();

  static const String _fakeKey = 'param_fake_focus_history_map';

  Future<Map<String, int>> loadData() async {
    final isFake = AppDeveloperConfig.useFakeData;
    final key = isFake ? _fakeKey : null;
    final storedData = await _service.getFocusHistory(key: key);

    if (isFake) {
      if (storedData.isNotEmpty) return storedData;
      final fakeData = getFakeFocusData();
      await _service.saveFocusHistory(fakeData, key: _fakeKey);
      return fakeData;
    }

    return storedData;
  }

  Future<void> saveData(Map<String, int> data) async {
    final key = AppDeveloperConfig.useFakeData ? _fakeKey : null;
    await _service.saveFocusHistory(data, key: key);
  }

  Future<void> saveFocusState({
    required bool isFocusing,
    DateTime? startTime,
  }) async {
    await _service.saveFocusState(isFocusing: isFocusing, startTime: startTime);
  }

  Future<(bool, DateTime?)> getFocusState() async {
    return await _service.getFocusState();
  }
}
