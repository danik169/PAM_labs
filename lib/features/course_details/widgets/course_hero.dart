import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../data/models/course.dart';

/// Imaginea mare din partea de sus a paginii de detalii.
class CourseHero extends StatelessWidget {
  const CourseHero({super.key, required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    final accent = Color(course.accentValue);
    final bottom = Color.lerp(accent, AppColors.orange, 0.7) ?? AppColors.orange;

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [accent, bottom],
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowStrong,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Text(
                course.heroLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow, size: 36, color: AppColors.orange),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InfoChip(
                    icon: Icons.video_library,
                    text: '${course.videoCount} Videos',
                  ),
                  const SizedBox(width: 8),
                  InfoChip(
                    icon: Icons.class_,
                    text: '${course.classCount} Class',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
