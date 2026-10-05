import 'package:flutter/material.dart';

import '../models/listing.dart';

/// Brand palette: deep indigo for trust, teal for energy, emerald for "verified".
class AppColors {
  AppColors._();

  static const primary = Color(0xFF1E3A8A); // indigo
  static const primaryDark = Color(0xFF111C4E);
  static const accent = Color(0xFF14B8A6); // teal
  static const verified = Color(0xFF059669); // emerald

  static const background = Color(0xFFF4F6FB);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const border = Color(0xFFE2E8F0);

  // Deadline urgency.
  static const urgent = Color(0xFFDC2626);
  static const soon = Color(0xFFD97706);
  static const comfortable = Color(0xFF059669);

  static const headerGradient = LinearGradient(
    colors: [primaryDark, primary, Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

extension ListingTypeStyle on ListingType {
  Color get color => switch (this) {
    ListingType.govtJob => const Color(0xFF1D4ED8),
    ListingType.privateJob => const Color(0xFF7C3AED),
    ListingType.scholarship => const Color(0xFF059669),
    ListingType.internship => const Color(0xFFEA580C),
  };

  IconData get icon => switch (this) {
    ListingType.govtJob => Icons.account_balance,
    ListingType.privateJob => Icons.business_center,
    ListingType.scholarship => Icons.school,
    ListingType.internship => Icons.rocket_launch,
  };
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: Colors.white,
    ),
    AppColors.background,
    AppColors.border,
  );

  static ThemeData dark() => _build(
    ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      secondary: AppColors.accent,
    ),
    const Color(0xFF0B1020),
    const Color(0xFF263050),
  );

  static ThemeData _build(ColorScheme scheme, Color bg, Color border) {
    final base = ThemeData(colorScheme: scheme, useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: bg,
      textTheme: base.textTheme.copyWith(
        headlineSmall: base.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
        titleMedium: base.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.25,
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: border),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: BorderSide(color: border),
        showCheckmark: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
