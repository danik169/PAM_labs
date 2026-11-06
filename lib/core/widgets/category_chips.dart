import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Listă orizontală de chip-uri pentru filtrare pe categorii.
/// `selected == null` înseamnă "All".
class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
    this.allLabel = 'All',
  });

  final List<String> categories;
  final String? selected;
  final ValueChanged<String?> onSelected;
  final String allLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _chip(allLabel, selected == null, () => onSelected(null)),
          for (final category in categories)
            _chip(category, selected == category, () => onSelected(category)),
        ],
      ),
    );
  }

  Widget _chip(String label, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        showCheckmark: false,
        selectedColor: AppColors.orange,
        backgroundColor: Colors.white,
        side: BorderSide(
          color: isSelected ? AppColors.orange : AppColors.trackGray,
        ),
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
