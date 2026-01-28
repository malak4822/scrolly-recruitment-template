import 'package:app/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChartHeader extends StatelessWidget {
  final String topLabel;
  final String mainValueText;
  final String subHeader;

  const ChartHeader({
    super.key,
    required this.topLabel,
    required this.mainValueText,
    required this.subHeader,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(topLabel, style: AppFonts.bodyLarge),
        SizedBox(height: 2.h),
        Text(subHeader, style: AppFonts.bodyLarge),
        SizedBox(height: 8.h),
        RichText(
          text: TextSpan(
            text: mainValueText,
            style: AppFonts.headlineLarge.copyWith(fontSize: 22.sp),
          ),
        ),
      ],
    );
  }
}
