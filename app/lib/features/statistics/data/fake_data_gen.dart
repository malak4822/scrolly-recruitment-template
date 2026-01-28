import 'package:intl/intl.dart';

Map<String, int> getFakeFocusData() {
  final now = DateTime.now();
  final Map<String, int> data = {};
  
  for (int i = 0; i < 28; i++) {
    final date = now.subtract(Duration(days: i));
    final key = DateFormat('yyyy-MM-dd').format(date);
    
    int minutes = 0;
    int base = 30;
    switch (date.weekday) {
      case DateTime.monday: base = 40; break;
      case DateTime.tuesday: base = 75; break;
      case DateTime.wednesday: base = 30; break;
      case DateTime.thursday: base = 45; break;
      case DateTime.friday: base = 60; break;
      case DateTime.saturday: base = 48; break;
      case DateTime.sunday: base = 55; break;
    }
    minutes = base + (i ~/ 7) * 5; 
    
    data[key] = minutes * 180; 
  }
  return data;
}
