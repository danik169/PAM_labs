import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Bara de jos: prețul și butonul "Enroll Now".
class EnrollBar extends StatelessWidget {
  const EnrollBar({
    super.key,
    required this.priceLabel,
    required this.onEnroll,
    this.actionLabel = 'Enroll Now',
  });

  final String priceLabel;
  final String actionLabel;
  final VoidCallback onEnroll;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.screenBg,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 94,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.trackGray),
                ),
                child: Text(
                  priceLabel,
                  style: const TextStyle(
                    color: AppColors.orange,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onEnroll,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      actionLabel,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
