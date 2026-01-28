import 'package:flutter/material.dart';
import '../../../constants/app_theme.dart';

class AppPadding extends StatelessWidget {
  final Widget child;

  const AppPadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppLayout.pagePadding),
        child: child,
      ),
    );
  }
}
