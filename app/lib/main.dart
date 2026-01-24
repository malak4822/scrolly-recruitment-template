// Scrolly Recruitment Kit - Flutter coding challenge template

import 'package:flutter/material.dart';
import 'package:app/constants/app_color.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColor.secondary,
        body: Center(
          child: Image.asset('assets/images/logo.png', width: 100, height: 100),
        ),
      ),
    );
  }
}
