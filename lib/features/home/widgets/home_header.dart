import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/home_data.dart';
import 'learned_today_card.dart';

/// Antetul albastru cu salut, notificări, avatar și cardul "Learned today".
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.data, required this.onMyCourses});

  final HomeData data;
  final VoidCallback onMyCourses;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 50,
          child: Container(color: AppColors.blue),
        ),
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.greeting,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.subtitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    _NotificationBell(hasUnread: data.hasUnreadNotifications),
                    const SizedBox(width: 14),
                    _Avatar(url: data.avatarUrl),
                  ],
                ),
                const SizedBox(height: 26),
                LearnedTodayCard(
                  title: data.learnedTitle,
                  learnedMinutes: data.learnedMinutes,
                  goalMinutes: data.goalMinutes,
                  progress: data.learnedProgress,
                  actionLabel: data.myCoursesLabel,
                  onAction: onMyCourses,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.hasUnread});

  final bool hasUnread;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.notifications_none, color: Colors.white, size: 30),
        if (hasUnread)
          Positioned(
            right: 3,
            top: 3,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.blue, width: 1.5),
              ),
            ),
          ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    const fallback = Icon(Icons.person, color: AppColors.blue, size: 34);
    return ClipOval(
      child: Container(
        width: 50,
        height: 50,
        color: AppColors.avatarBg,
        child: url.isEmpty
            ? fallback
            : Image.network(
                url,
                fit: BoxFit.cover,
                // Fără internet / URL greșit: rămâne iconița din lab2.
                errorBuilder: (context, error, stackTrace) => fallback,
              ),
      ),
    );
  }
}
