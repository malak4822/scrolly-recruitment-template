import 'package:app/constants/app_color.dart';
import 'package:app/constants/app_shadows.dart';
import 'package:app/features/statistics/cubit/focus_stats_cubit.dart';
import 'package:app/features/statistics/cubit/focus_stats_state.dart';
import 'package:app/features/statistics/utils/time_utils.dart';
import 'package:app/features/statistics/widgets/components/weekly_report_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeeklyChartWidget extends StatefulWidget {
  const WeeklyChartWidget({super.key});

  @override
  State<WeeklyChartWidget> createState() => _WeeklyChartWidgetState();
}

class _WeeklyChartWidgetState extends State<WeeklyChartWidget> {
  DateTime? _selectedDate;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<FocusStatsCubit>();

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          width: 348.w,
          height: 328.h,
          padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 30.h),
          decoration: BoxDecoration(
            color: AppColor.card,
            borderRadius: BorderRadius.circular(47.r),
            boxShadow: AppShadows.defaultShadow,
          ),
          child: PageView.builder(
            itemCount: cubit.state.weeklyChartPageCount,
            reverse: true,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (_) => setState(() {
              _selectedDate = null;
            }),
            itemBuilder: (context, index) => WeeklyReportView(
              viewModel: cubit.state.getWeeklyChartData(
                index,
                _selectedDate,
              ),
              onDateSelect: (date) => setState(() {
                if (_selectedDate != null &&
                    TimeUtils.isSameDay(_selectedDate!, date)) {
                  _selectedDate = null;
                } else {
                  _selectedDate = date;
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}
