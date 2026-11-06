import 'package:flutter/material.dart';

/// Paleta de culori folosită în toată aplicația (preluată din lab2).
class AppColors {
  const AppColors._();

  static const Color blue = Color(0xFF465BFA);
  static const Color orange = Color(0xFFEE7B30);
  static const Color orangeLight = Color(0xFFFFF1E7);
  static const Color orangeFade = Color(0xFFFFE0CC);
  static const Color lightBlueCard = Color(0xFFD6EAFB);
  static const Color purpleCard = Color(0xFFEDE0FA);
  static const Color purpleDark = Color(0xFF3B0F7D);
  static const Color screenBg = Color(0xFFF9FAFD);
  static const Color textDark = Color(0xFF14142B);
  static const Color textGray = Color(0xFF9A9AB0);
  static const Color trackGray = Color(0xFFEDEDF4);
  static const Color red = Color(0xFFFF4D6D);
  static const Color avatarBg = Color(0xFFFFE3E3);

  // Umbre (negru cu transparență fixă)
  static const Color shadowSoft = Color(0x12000000); // ~7%
  static const Color shadow = Color(0x1A000000); // ~10%
  static const Color shadowStrong = Color(0x26000000); // ~15%
}
