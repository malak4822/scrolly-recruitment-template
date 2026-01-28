import 'package:app/constants/app_color.dart';
import 'package:app/constants/app_fonts.dart';
import 'package:app/features/statistics/cubit/focus_stats_cubit.dart';
import 'package:app/features/statistics/cubit/focus_stats_state.dart';
import 'package:app/features/statistics/utils/focus_calculator.dart';
import 'package:app/features/statistics/widgets/weekly_chart_widget.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:app/features/common/widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:app/features/common/widgets/app_padding.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AppPadding(
        child: Column(
          children: [
            Text('statistics', style: AppFonts.headlineLarge),
            SizedBox(height: 24.h),
            BlocBuilder<FocusStatsCubit, FocusStatsState>(
              builder: (context, state) {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    children: [
                      StatCard(
                        icon: Assets.icons.flame,
                        label: 'Current\ndays streak',
                        labelSuffix: '${state.totalDaysWithFocus} days',
                        value: '${state.currentStreak}',
                        backgroundColor: AppColor.primary,
                        textColor: AppColor.background,
                      ),
                      SizedBox(width: 18.w),
                      StatCard(
                        icon: Assets.icons.time,
                        label: 'Focus\ntime today',
                        labelSuffix: FocusCalculator.calculateOverallTime(
                          state.totalOverallSeconds,
                        ),
                        value: FocusCalculator.formatTodayTime(
                          state.todayTotalSeconds,
                          showSeconds: false,
                        ),
                        backgroundColor: AppColor.card,
                        tagColor: AppColor.darkCard,
                        textColor: AppColor.primary,
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 44.h),
            const WeeklyChartWidget(),
          ],
        ),
      ),
    );
  }
}
