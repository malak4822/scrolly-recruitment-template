import 'package:app/features/statistics/cubit/focus_stats_cubit.dart';
import 'package:app/features/statistics/cubit/focus_stats_state.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageToggled extends StatelessWidget {
  const ImageToggled({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FocusStatsCubit, FocusStatsState>(
      builder: (context, state) {
        final isFocused = state.isFocusing;
        const duration = Duration(milliseconds: 200);

        return GestureDetector(
          onTap: context.read<FocusStatsCubit>().toggleFocus,
          child: AnimatedSwitcher(
            duration: duration,
            transitionBuilder: (child, animation) =>
                FadeTransition(opacity: animation, child: child),
            child: Image.asset(
              key: ValueKey(isFocused),
              isFocused
                  ? Assets.images.scrollyFrontHappy.path
                  : Assets.images.scrollyFrontAngry.path,
              width: 234.w,
              height: 240.h,
            ),
          ),
        );
      },
    );
  }
}
