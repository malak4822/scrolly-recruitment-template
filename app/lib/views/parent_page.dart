import 'package:app/constants/app_color.dart';
import 'package:app/features/navigation/cubit/navigation_cubit.dart';
import 'package:app/views/scrolly_page.dart';
import 'package:app/views/statistics_page.dart';
import 'package:app/features/navigation/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ParentPage extends StatelessWidget {
  const ParentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [const ScrollyPage(), const StatisticsPage()];

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          backgroundColor: AppColor.background,
          body: IndexedStack(index: currentIndex, children: pages),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: currentIndex,
            onTap: (i) => context.read<NavigationCubit>().setPage(i),
          ),
        );
      },
    );
  }
}
