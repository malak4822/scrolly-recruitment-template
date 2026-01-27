import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app/constants/app_color.dart';

class AppFonts {
  static const _baseFamily = GoogleFonts.poppins;

  
  static final displayLarge = _baseFamily(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    color: AppColor.background,
  );

  static final headlineLarge = _baseFamily(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColor.primary,
  );

  static final displayMedium = _baseFamily(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
  );

  static final headlineMedium = _baseFamily(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
  );

  // Body Text (Mixed Defaults based on usage frequency)

  /// Primary 19px w500 (Previously 'extraMedium')
  static final bodyLarge = _baseFamily(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
  );

  static final bodyMedium = _baseFamily(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColor.background,
  );

  static final bodySmall = _baseFamily(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.background,
  );


  static final labelLarge = _baseFamily(
    fontSize: 12.7,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
  );

  static final labelSmall = _baseFamily(
    fontSize: 10.645,
    fontWeight: FontWeight.w500,
    color: AppColor.background,
  );
}
