import 'package:app/constants/constants.dart';
import 'package:app/features/statistics/cubit/focus_stats_cubit.dart';
import 'package:app/features/statistics/cubit/focus_stats_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FocusButton extends StatelessWidget {
  const FocusButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FocusStatsCubit, FocusStatsState>(
      builder: (context, state) {
        final isFocused = state.isFocusing;

        return GestureDetector(
          onTap: context.read<FocusStatsCubit>().toggleFocus,
          child: Container(
            width: 126.w,
            height: 41.h,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(
                AppLayout.borderRadiusSmall.r,
              ),
              boxShadow: AppShadows.focusButtonShadow,
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  isFocused ? 'Tap to unfocus' : 'Tap to focus',
                  style: AppFonts.bodySmall,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
