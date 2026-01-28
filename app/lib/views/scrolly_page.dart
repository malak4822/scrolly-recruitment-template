import 'package:app/constants/constants.dart';
import 'package:app/features/common/widgets/app_padding.dart';
import 'package:app/features/scrolly/widgets/focus_button.dart';
import 'package:app/features/scrolly/widgets/focus_time_box_widget.dart';
import 'package:app/features/scrolly/widgets/image_toggled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScrollyPage extends StatelessWidget {
  const ScrollyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: AppPadding(
          child: Column(
            children: [
              Text('scrolly', style: AppFonts.headlineLarge),
              SizedBox(height: 69.13.h),
              const FocusTimeBoxWidget(),
              SizedBox(height: 70.h),
              const ImageToggled(),
              SizedBox(height: 64.h),
              const FocusButton(),
            ],
          ),
      ),
    );
  }
}
