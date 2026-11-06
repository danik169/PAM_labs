import 'package:flutter/material.dart';

/// Transformă cheia `icon` din JSON într-un [IconData] Material.
IconData iconForKey(String key) {
  switch (key) {
    case 'code':
      return Icons.code;
    case 'data':
      return Icons.bar_chart;
    case 'design':
      return Icons.palette_outlined;
    case 'language':
      return Icons.translate;
    case 'business':
      return Icons.trending_up;
    default:
      return Icons.school;
  }
}
