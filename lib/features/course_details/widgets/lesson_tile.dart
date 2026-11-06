import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/lesson.dart';

/// Un rând din lista de lecții (play / blocat / finalizat).
class LessonTile extends StatelessWidget {
  const LessonTile({
    super.key,
    required this.lesson,
    required this.highlighted,
    required this.onTap,
  });

  final Lesson lesson;
  final bool highlighted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    final Color iconColor;
    if (lesson.locked) {
      icon = Icons.lock_outline;
      iconColor = AppColors.textGray;
    } else if (lesson.completed) {
      icon = Icons.check;
      iconColor = highlighted ? Colors.white : AppColors.orange;
    } else {
      icon = Icons.play_arrow;
      iconColor = highlighted ? Colors.white : AppColors.orange;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: highlighted ? AppColors.orange : Colors.white,
                shape: BoxShape.circle,
                boxShadow: highlighted
                    ? null
                    : const [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: lesson.locked
                          ? AppColors.textGray
                          : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lesson.duration} min',
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.textGray,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 30,
              color: lesson.locked ? AppColors.orangeFade : AppColors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
