import 'package:app/features/common/widgets/app_lifecycle_handler.dart';
import 'package:app/features/navigation/cubit/navigation_cubit.dart';
import 'package:app/views/parent_page.dart';

import 'package:app/features/statistics/cubit/focus_stats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => FocusStatsCubit()),
            BlocProvider(create: (context) => NavigationCubit()),
          ],
          child: const AppLifecycleHandler(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: ParentPage(),
            ),
          ),
        );
      },
    );
  }
}
