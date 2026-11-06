import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/icon_mapper.dart';
import '../../../core/widgets/favorite_button.dart';
import '../../../core/widgets/info_widgets.dart';
import '../../../data/models/course.dart';

/// Cardul unui curs din listă (reutilizabil).
class CourseCard extends StatelessWidget {
  const CourseCard({
    super.key,
    required this.course,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteTap,
  });

  final Course course;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;

  @override
  Widget build(BuildContext context) {
    final accent = Color(course.accentValue);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: accent.withAlpha(32),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(iconForKey(course.iconKey), size: 34, color: accent),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                course.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ),
                          ),
                          FavoriteButton(
                            isFavorite: isFavorite,
                            onPressed: onFavoriteTap,
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${course.category} · ${course.level}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textGray,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 10,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          RatingBadge(rating: course.rating, compact: true),
                          IconText(icon: Icons.schedule, text: course.duration),
                          IconText(
                            icon: Icons.menu_book_outlined,
                            text: '${course.lessonCount} lessons',
                          ),
                          Text(
                            course.priceLabel,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: course.isFree
                                  ? AppColors.orange
                                  : AppColors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
