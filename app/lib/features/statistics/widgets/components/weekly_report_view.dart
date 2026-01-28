import 'package:app/features/statistics/data/models/weekly_chart_view_model.dart';
import 'package:app/features/statistics/widgets/components/chart_header.dart';
import 'package:app/features/statistics/widgets/components/weekly_chart_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeeklyReportView extends StatelessWidget {
  final WeeklyChartViewModel viewModel;
  final Function(DateTime) onDateSelect;

  const WeeklyReportView({
    super.key,
    required this.viewModel,
    required this.onDateSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChartHeader(
          topLabel: viewModel.topLabel,
          mainValueText: viewModel.mainValueText,
          subHeader: viewModel.subHeader,
        ),
        SizedBox(height: 16.h),
        Expanded(
          child: WeeklyChartView(
            viewModel: viewModel,
            onDateSelect: onDateSelect,
          ),
        ),
      ],
    );
  }
}
