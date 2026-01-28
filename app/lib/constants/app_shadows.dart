import 'package:flutter/material.dart';

class AppShadows {
  static const defaultShadow = [
    BoxShadow(
      color: Color(0x4D000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x26000000),
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 3,
    ),
  ];

  static const focusButtonShadow = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.15),
      offset: Offset(0, 3.047),
      blurRadius: 6.093,
      spreadRadius: 2.285,
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.30),
      offset: Offset(0, 0.762),
      blurRadius: 2.285,
      spreadRadius: 0,
    ),
  ];
}
