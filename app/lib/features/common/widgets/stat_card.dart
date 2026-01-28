import 'package:app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatCard extends StatefulWidget {
  final String icon;
  final String label;
  final String labelSuffix;
  final String value;
  final Color backgroundColor;
  final Color tagColor;
  final Color textColor;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.labelSuffix,
    required this.value,
    this.backgroundColor = AppColor.primary,
    this.tagColor = Colors.transparent,
    this.textColor = AppColor.background,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Container(
          width: 165.w,
          height: 190.h,
          padding: .all(AppLayout.pagePaddingHorizontal),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(AppLayout.borderRadiusBig.r),
            boxShadow: AppShadows.defaultShadow,
          ),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .spaceEvenly,
            children: [
              Text(widget.label, style: AppFonts.bodyLarge.copyWith(color: widget.textColor)),
              Row(
                children: [
                  SvgPicture.asset(
                    widget.icon,
                    width: 26.w,
                    height: 26.h,
                    colorFilter: ColorFilter.mode(widget.textColor, BlendMode.srcIn),
                  ),
                  SizedBox(width: 4.45.w),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.value,
                        style: AppFonts.displayMedium.copyWith(color: widget.textColor),
                      ),
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppLayout.borderRadiusLittleSmall.r),
                child: ColoredBox(
                  color: widget.tagColor,
                  child: Padding(
                    padding: .symmetric(horizontal: 12.w, vertical: 2.h),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${widget.labelSuffix} overall',
                          style: AppFonts.labelLarge.copyWith(color: widget.textColor),
                        ),
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
