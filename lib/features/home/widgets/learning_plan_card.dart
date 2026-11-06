import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../data/models/home_data.dart';

class LearningPlanCard extends StatelessWidget {
  const LearningPlanCard({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  final List<PlanItem> items;
  final ValueChanged<PlanItem> onItemTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      // Material transparent: altfel efectul de ripple al InkWell ar fi
      // acoperit de fundalul alb al cardului.
      child: Material(
        color: Colors.transparent,
        child: Column(
          children: [
            for (final item in items)
              _PlanRow(item: item, onTap: () => onItemTap(item)),
          ],
        ),
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  const _PlanRow({required this.item, required this.onTap});

  final PlanItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                value: item.progress.clamp(0.0, 1.0).toDouble(),
                strokeWidth: 3,
                color: AppColors.textDark,
                backgroundColor: AppColors.trackGray,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 17, color: AppColors.textDark),
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${item.completed}',
                    style: const TextStyle(fontSize: 17, color: AppColors.textDark),
                  ),
                  TextSpan(
                    text: '/${item.total}',
                    style: const TextStyle(fontSize: 17, color: AppColors.textGray),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
