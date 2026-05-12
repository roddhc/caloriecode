import 'package:flutter/material.dart';

class DesignColors {
  // Light Mode Colors
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color warningOrange = Color(0xFFF57C00);
  static const Color dangerRed = Color(0xFFC62828);
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color textDark = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textTertiary = Color(0xFFBDBDBD);

  // Dark Mode Colors
  static const Color successGreenDark = Color(0xFF66BB6A);
  static const Color warningOrangeDark = Color(0xFFFFB74D);
  static const Color dangerRedDark = Color(0xFFEF5350);
  static const Color lightGrayDark = Color(0xFF424242);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color textLight = Color(0xFFE8E8E8);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);

  // Decision Card Backgrounds
  static const Color greenLightBg = Color(0xFFE8F5E9);
  static const Color orangeLightBg = Color(0xFFFFF3E0);
  static const Color redLightBg = Color(0xFFFFEBEE);

  static Color getSuccessGreen(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? successGreen
        : successGreenDark;
  }

  static Color getWarningOrange(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? warningOrange
        : warningOrangeDark;
  }

  static Color getDangerRed(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? dangerRed
        : dangerRedDark;
  }

  static Color getPrimaryBlue(BuildContext context) {
    // Same for light and dark
    return primaryBlue;
  }

  static Color getLightGray(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? lightGray
        : lightGrayDark;
  }

  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? backgroundLight
        : backgroundDark;
  }

  static Color getTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? textDark
        : textLight;
  }

  static Color getTextSecondaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? textSecondary
        : textSecondaryDark;
  }

  static Color getTextTertiaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? textTertiary
        : textTertiary; // Same as dark secondary
  }
}
