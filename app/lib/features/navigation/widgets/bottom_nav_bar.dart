import 'package:app/constants/constants.dart';
import 'package:app/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 87.h,
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppLayout.borderRadiusBottom.r),
          topRight: Radius.circular(AppLayout.borderRadiusBottom.r),
        ),
      ),
      child: SizedBox(
        width: 170.w,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: .spaceBetween,
          children: [
            _NavItem(
              icon: Assets.icons.home,
              label: 'Scrolly',
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            _NavItem(
              icon: Assets.icons.stats,
              label: 'Statistics',
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Na figmie nie ma jaki to ma shadow więc nie daje
          SvgPicture.asset(
            icon,
            width: 24.w,
            height: 24.h,
            colorFilter: ColorFilter.mode(
              isActive ? AppColor.background : AppColor.secondary,
              BlendMode.srcIn,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            label,
            style: AppFonts.labelSmall.copyWith(
              color: isActive ? AppColor.background : AppColor.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
