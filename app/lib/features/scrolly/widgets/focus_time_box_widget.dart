import 'package:app/constants/constants.dart';
import 'package:app/features/statistics/cubit/focus_stats_cubit.dart';
import 'package:app/features/statistics/cubit/focus_stats_state.dart';
import 'package:app/features/statistics/utils/focus_calculator.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FocusTimeBoxWidget extends StatefulWidget {
  const FocusTimeBoxWidget({super.key});

  @override
  State<FocusTimeBoxWidget> createState() => _FocusTimeBoxWidgetState();
}

class _FocusTimeBoxWidgetState extends State<FocusTimeBoxWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FocusStatsCubit, FocusStatsState>(
      builder: (context, state) {
        final totalSeconds = state.todayTotalSeconds;
        final timeString = FocusCalculator.formatTodayTime(totalSeconds);

        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            child: Container(
              width: 340.w,
              height: 120.h,
              padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(
                  AppLayout.borderRadiusMedium.r,
                ),
                boxShadow: AppShadows.defaultShadow,
              ),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .spaceAround,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        Assets.icons.time,
                        width: 26.w,
                        height: 26.h,
                        colorFilter: const ColorFilter.mode(
                          AppColor.background,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text('Focus time today', style: AppFonts.bodyMedium),
                    ],
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      timeString,
                      style: AppFonts.displayLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
