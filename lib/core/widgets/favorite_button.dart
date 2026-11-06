import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Butonul "inimioară" pentru adăugare / eliminare din favorite.
class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
    this.size = 24,
  });

  final bool isFavorite;
  final VoidCallback? onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey<bool>(isFavorite),
          size: size,
          color: isFavorite ? AppColors.red : AppColors.textGray,
        ),
      ),
    );
  }
}
