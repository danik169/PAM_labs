import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class TabLabel extends StatelessWidget {
  const TabLabel({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: active
                    ? AppColors.orange
                    : AppColors.textGray.withAlpha(153),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: active ? 76 : 0,
              height: 2,
              color: AppColors.orange,
            ),
          ],
        ),
      ),
    );
  }
}
