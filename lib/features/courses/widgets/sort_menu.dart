import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../cubit/courses_state.dart';

/// Meniul de sortare (buton în bara de sus).
class SortMenu extends StatelessWidget {
  const SortMenu({
    super.key,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
  });

  final CourseSort selected;
  final ValueChanged<CourseSort> onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<CourseSort>(
      enabled: enabled,
      tooltip: 'Sort',
      initialValue: selected,
      onSelected: onSelected,
      icon: const Icon(Icons.sort, color: AppColors.textDark),
      itemBuilder: (context) => <PopupMenuEntry<CourseSort>>[
        for (final option in CourseSort.values)
          CheckedPopupMenuItem<CourseSort>(
            value: option,
            checked: option == selected,
            child: Text(option.label),
          ),
      ],
    );
  }
}
