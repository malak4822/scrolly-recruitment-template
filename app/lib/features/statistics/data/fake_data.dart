
import 'package:intl/intl.dart';

Map<String, int> getFakeFocusData() {
  final now = DateTime.now();
  final Map<String, int> data = {};
  
  // Generate data 4 weeks
  for (int i = 0; i < 28; i++) {
    final date = now.subtract(Duration(days: i));
    final key = DateFormat('yyyy-MM-dd').format(date);
    
    // Simple pattern generation based on day of week or index
    int minutes = 0;
    // Base pattern: 30-90 minutes
    int base = 30;
    switch (i % 7) {
      case 0: base = 55; break;
      case 1: base = 40; break;
      case 2: base = 75; break;
      case 3: base = 30; break;
      case 4: base = 45; break;
      case 5: base = 60; break;
      case 6: base = 48; break;
    }
    // Add small variance based on week
    minutes = base + (i ~/ 7) * 5; 
    
    data[key] = minutes * 580; 
  }
  return data;
}
