import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class LearnedTodayCard extends StatelessWidget {
  const LearnedTodayCard({
    super.key,
    required this.title,
    required this.learnedMinutes,
    required this.goalMinutes,
    required this.progress,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final int learnedMinutes;
  final int goalMinutes;
  final double progress;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.textGray, fontSize: 14),
              ),
              GestureDetector(
                onTap: onAction,
                behavior: HitTestBehavior.opaque,
                child: Text(
                  actionLabel,
                  style: const TextStyle(color: AppColors.blue, fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${learnedMinutes}min',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                TextSpan(
                  text: ' / ${goalMinutes}min',
                  style: const TextStyle(fontSize: 13, color: AppColors.textGray),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0).toDouble(),
              minHeight: 6,
              color: AppColors.orange,
              backgroundColor: AppColors.trackGray,
            ),
          ),
        ],
      ),
    );
  }
}
