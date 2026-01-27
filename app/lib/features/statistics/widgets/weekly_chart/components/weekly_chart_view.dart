import 'package:app/constants/app_color.dart';
import 'package:app/constants/app_fonts.dart';
import 'package:app/features/statistics/widgets/weekly_chart/components/chart_bar.dart';
import 'package:app/features/statistics/widgets/weekly_chart/components/dashed_line_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeeklyChartView extends StatelessWidget {
  final List<Map<String, dynamic>> weekData;
  final DateTime? selectedDate;
  final double avgMinutes;
  final double safeMax;
  final ValueChanged<DateTime> onDateSelect;

  const WeeklyChartView({
    super.key,
    required this.weekData,
    required this.selectedDate,
    required this.avgMinutes,
    required this.safeMax,
    required this.onDateSelect,
  });

  @override
  Widget build(BuildContext context) {
    final double chartHeight = 145.h;
    final double avgLineBottom = (avgMinutes / safeMax) * chartHeight;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w),
          height: double.infinity,
          alignment: Alignment.bottomLeft, 
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: .end,
              mainAxisAlignment: .start,
              children: [
                for (int i = 0; i < weekData.length; i++) ...[
                  if (i > 0) SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () => onDateSelect(weekData[i]['date'] as DateTime),
                    child: ChartBar(
                      height:
                          ((weekData[i]['minutes'] as double) /
                          safeMax *
                          chartHeight),
                      dayLabel: weekData[i]['dayLabel'] as String,
                      isHighlighted: selectedDate != null
                          ? _isSameDay(
                              weekData[i]['date'] as DateTime,
                              selectedDate!,
                            )
                          : false,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        if (avgMinutes > 0)
          Positioned(
            bottom: avgLineBottom,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('avg', style: AppFonts.labelLarge),
                  SizedBox(height: 6.h),
                  CustomPaint(
                    size: Size(double.infinity, 1),
                    painter: DashedLinePainter(color: AppColor.primary),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
