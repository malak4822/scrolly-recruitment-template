import 'package:app/constants/app_color.dart';
import 'package:app/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChartBar extends StatelessWidget {
  final double height;
  final String dayLabel;
  final bool isHighlighted;

  const ChartBar({
    super.key,
    required this.height,
    required this.dayLabel,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 33.w,
          height: height,
          decoration: BoxDecoration(
            color: isHighlighted ? AppColor.chart : AppColor.darkCard,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          width: 32.w,
          child: Text(
            dayLabel,
            textAlign: TextAlign.center,
            style: AppFonts.labelLarge.copyWith(
              color: AppColor.primaryDark,
            ),
          ),
        ),
      ],
    );
  }
}
