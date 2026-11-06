import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Starea **Loading**.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final text = message;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.orange),
          if (text != null) ...[
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(color: AppColors.textGray, fontSize: 15),
            ),
          ],
        ],
      ),
    );
  }
}

/// Starea **Error** (cu buton de reîncercare).
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return _StatusMessage(
      icon: Icons.cloud_off_outlined,
      iconColor: AppColors.red,
      title: 'Something went wrong',
      message: message,
      actionLabel: 'Try again',
      actionIcon: Icons.refresh,
      onAction: onRetry,
    );
  }
}

/// Starea **Empty** (nu există rezultate).
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.search_off,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return _StatusMessage(
      icon: icon,
      iconColor: AppColors.blue,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final label = actionLabel;
    final callback = onAction;
    final buttonIcon = actionIcon;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: AppColors.orange,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: iconColor),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                height: 1.4,
                color: AppColors.textGray,
              ),
            ),
            if (label != null && callback != null) ...[
              const SizedBox(height: 24),
              if (buttonIcon != null)
                ElevatedButton.icon(
                  onPressed: callback,
                  style: buttonStyle,
                  icon: Icon(buttonIcon, size: 20),
                  label: Text(label),
                )
              else
                ElevatedButton(
                  onPressed: callback,
                  style: buttonStyle,
                  child: Text(label),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
