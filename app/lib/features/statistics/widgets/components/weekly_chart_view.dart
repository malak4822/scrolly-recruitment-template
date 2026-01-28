import 'package:app/constants/app_color.dart';
import 'package:app/constants/app_fonts.dart';
import 'package:app/features/statistics/utils/time_utils.dart';
import 'package:app/features/statistics/widgets/components/chart_bar.dart';
import 'package:app/features/statistics/data/models/weekly_chart_view_model.dart';
import 'package:app/features/statistics/widgets/components/dashed_line_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeeklyChartView extends StatelessWidget {
  final WeeklyChartViewModel viewModel;
  final ValueChanged<DateTime> onDateSelect;

  const WeeklyChartView({
    super.key,
    required this.viewModel,
    required this.onDateSelect,
  });

  @override
  Widget build(BuildContext context) {
    final double chartHeight = 145.h;
    final double avgLineBottom = (viewModel.avgMinutes / viewModel.safeMax) * chartHeight;

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
                for (int i = 0; i < viewModel.weekData.length; i++) ...[
                  if (i > 0) SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () => onDateSelect(viewModel.weekData[i].date),
                    child: ChartBar(
                      height:
                          (viewModel.weekData[i].minutes /
                          viewModel.safeMax *
                          chartHeight),
                      dayLabel: viewModel.weekData[i].dayLabel,
                      isHighlighted: viewModel.selectedDate != null
                          ? TimeUtils.isSameDay(
                              viewModel.weekData[i].date,
                              viewModel.selectedDate!,
                            )
                          : false,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        if (viewModel.avgMinutes > 0)
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
}
