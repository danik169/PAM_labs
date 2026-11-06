import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class MeetupCard extends StatelessWidget {
  const MeetupCard({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [AppColors.purpleCard, Color(0xFFEBDDF8)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 18,
            right: 120,
            top: 0,
            bottom: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.purpleDark,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: AppColors.purpleDark),
                ),
              ],
            ),
          ),
          const Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Icon(Icons.groups, size: 90, color: AppColors.blue),
          ),
        ],
      ),
    );
  }
}
