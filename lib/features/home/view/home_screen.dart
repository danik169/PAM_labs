import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/state_views.dart';
import '../../../data/models/home_data.dart';
import '../../course_details/view/course_details_screen.dart';
import '../../courses/cubit/courses_cubit.dart';
import '../../courses/view/courses_screen.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_header.dart';
import '../widgets/learning_plan_card.dart';
import '../widgets/meetup_card.dart';
import '../widgets/promo_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          switch (state.status) {
            case HomeStatus.loading:
              return const LoadingView(message: 'Loading...');
            case HomeStatus.error:
              return ErrorView(
                message: state.errorMessage ?? 'Unknown error.',
                onRetry: () => context.read<HomeCubit>().load(),
              );
            case HomeStatus.success:
              return _HomeContent(data: state.data!);
          }
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.data});

  final HomeData data;

  void _openCourses(BuildContext context) {
    Navigator.of(context).push(CoursesScreen.route());
  }

  /// Un element din Learning Plan deschide direct detaliile cursului
  /// (dacă există în catalog), altfel lista de cursuri.
  void _openPlanItem(BuildContext context, PlanItem item) {
    final courses = context.read<CoursesCubit>().state.allCourses;
    final matches = courses.where((course) => course.id == item.id);
    if (matches.isEmpty) {
      _openCourses(context);
    } else {
      Navigator.of(context).push(CourseDetailsScreen.route(matches.first));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeHeader(data: data, onMyCourses: () => _openCourses(context)),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PromoBanner(
                title: data.promptTitle,
                actionLabel: data.promptActionLabel,
                onTap: () => _openCourses(context),
              ),
            ),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                data.planTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: LearningPlanCard(
                items: data.plan,
                onItemTap: (item) => _openPlanItem(context, item),
              ),
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MeetupCard(
                title: data.meetupTitle,
                subtitle: data.meetupSubtitle,
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
