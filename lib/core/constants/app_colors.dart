import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFF6B35);
  static const Color secondary = Color(0xFFFF8A50);
  static const Color accent = Color(0xFFFFA726);

  // Background & Surface
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color white = Colors.white;
  static const Color cardBg = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF2E2E2E);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);

  // Divider & Borders
  static const Color divider = Color(0xFFE0E0E0);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF2196F3);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF6B35), Color(0xFFFF8A50)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF8A50), Color(0xFFFFA726)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFA726), Color(0xFFFFB84D)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF5F1),
      Color(0xFFFFE8DC),
      Color(0xFFFAFAFA),
    ],
  );

  // Glassmorphism Colors
  static Color glassLight = Colors.white.withValues(alpha: 0.2);
  static Color glassMedium = Colors.white.withValues(alpha: 0.1);
  static Color glassDark = Colors.black.withValues(alpha: 0.05);

  // Favorite/Heart Color
  static const Color favorite = Color(0xFFE91E63);
  static const Color favoriteLight = Color(0xFFFFC1E3);
}
