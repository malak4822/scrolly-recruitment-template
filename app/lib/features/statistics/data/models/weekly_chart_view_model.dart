class WeeklyChartViewModel {
  final List<WeeklyChartBarData> weekData;
  final DateTime? selectedDate;
  final double avgMinutes;
  final double safeMax;
  final String topLabel;
  final String mainValueText;
  final String subHeader;

  const WeeklyChartViewModel({
    required this.weekData,
    required this.selectedDate,
    required this.avgMinutes,
    required this.safeMax,
    required this.topLabel,
    required this.mainValueText,
    required this.subHeader,
  });
}

class WeeklyChartBarData {
  final DateTime date;
  final String dayLabel;
  final double minutes;

  const WeeklyChartBarData({
    required this.date,
    required this.dayLabel,
    required this.minutes,
  });
}
