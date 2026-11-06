import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../data/models/course.dart';
import '../../../data/models/lesson.dart';
import '../../courses/cubit/courses_cubit.dart';
import '../../courses/cubit/courses_state.dart';
import '../widgets/course_hero.dart';
import '../widgets/enroll_bar.dart';
import '../widgets/lesson_tile.dart';
import '../widgets/tab_label.dart';

/// Pagina de detalii a unui curs (navigare din listă sau din Learning Plan).
class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({super.key, required this.course});

  final Course course;

  static Route<void> route(Course course) {
    return MaterialPageRoute<void>(
      builder: (_) => CourseDetailsScreen(course: course),
    );
  }

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  int _selectedTab = 0;

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  void _onLessonTap(Lesson lesson) {
    if (lesson.locked) {
      _showMessage('Enroll in the course to unlock "${lesson.title}".');
    } else {
      _showMessage('Starting "${lesson.title}"...');
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.screenBg,
        bottomNavigationBar: EnrollBar(
          priceLabel: course.priceLabel,
          onEnroll: () => _showMessage('You enrolled in "${course.title}".'),
        ),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopBar(context, course),
                CourseHero(course: course),
                const SizedBox(height: 22),
                Text(
                  '${course.category} · ${course.level}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 18, color: AppColors.textGray),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${course.duration}  ·  ${course.lessonCount} lessons',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textGray,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    RatingBadge(rating: course.rating),
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TabLabel(
                      label: 'Lessons',
                      active: _selectedTab == 0,
                      onTap: () => setState(() => _selectedTab = 0),
                    ),
                    TabLabel(
                      label: 'Description',
                      active: _selectedTab == 1,
                      onTap: () => setState(() => _selectedTab = 1),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (_selectedTab == 0)
                  _buildLessons(course)
                else
                  Text(
                    course.description.isEmpty
                        ? 'No description available.'
                        : course.description,
                    style: const TextStyle(
                      color: AppColors.textGray,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, Course course) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(width: 6),
          const Expanded(
            child: Text(
              'Course Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.textDark,
              ),
            ),
          ),
          // Se reconstruiește doar când se schimbă favorita acestui curs.
          BlocSelector<CoursesCubit, CoursesState, bool>(
            selector: (state) => state.isFavorite(course.id),
            builder: (context, isFavorite) {
              return FavoriteButton(
                isFavorite: isFavorite,
                size: 28,
                onPressed: () {
                  context.read<CoursesCubit>().toggleFavorite(course.id);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLessons(Course course) {
    if (course.lessons.isEmpty) {
      return const Text(
        'No lessons available yet.',
        style: TextStyle(color: AppColors.textGray, fontSize: 16),
      );
    }
    return Column(
      children: [
        for (var i = 0; i < course.lessons.length; i++) ...[
          LessonTile(
            lesson: course.lessons[i],
            highlighted: i == 0 && !course.lessons[i].locked,
            onTap: () => _onLessonTap(course.lessons[i]),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}
