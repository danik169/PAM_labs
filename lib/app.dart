import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/course_repository.dart';
import 'features/courses/cubit/courses_cubit.dart';
import 'features/home/cubit/home_cubit.dart';
import 'features/home/view/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.repository});

  /// Se poate injecta un repository fals în teste.
  final CourseRepository? repository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<CourseRepository>(
      create: (_) => repository ?? AssetCourseRepository(),
      child: MultiBlocProvider(
        providers: [
          // Cubit-urile sunt create deasupra MaterialApp, deci sunt accesibile
          // din toate ecranele (Home, Courses, Course details).
          BlocProvider<HomeCubit>(
            lazy: false,
            create: (context) =>
                HomeCubit(context.read<CourseRepository>())..load(),
          ),
          BlocProvider<CoursesCubit>(
            lazy: false,
            create: (context) =>
                CoursesCubit(context.read<CourseRepository>())..load(),
          ),
        ],
        child: MaterialApp(
          title: 'Learning App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
