import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppRadii {
  static const pill = 999.0;
  static const player = 20.0;
  static const card = 18.0;
  static const stat = 16.0;
  static const input = 14.0;
  static const button = 12.0;
}

class AppSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 28.0;
}

/// Latin UI typeface (Work Sans) — used for all UI chrome and translations.
TextStyle latinFont({required double size, FontWeight weight = FontWeight.w400, Color? color, double? height}) {
  return GoogleFonts.workSans(fontSize: size, fontWeight: weight, color: color, height: height);
}

/// Quranic Arabic typeface (Amiri) — always RTL, generous line-height.
TextStyle arabicFont({required double size, FontWeight weight = FontWeight.w400, Color? color, double? height}) {
  return GoogleFonts.amiri(fontSize: size, fontWeight: weight, color: color, height: height);
}

/// Monospace label typeface — used for concept/tag chips (Figma-inspired accent).
TextStyle monoFont({required double size, FontWeight weight = FontWeight.w600, Color? color, double? letterSpacing}) {
  return GoogleFonts.jetBrainsMono(fontSize: size, fontWeight: weight, color: color, letterSpacing: letterSpacing ?? 0.4);
}

class AppTheme {
  static ThemeData light() => _build(AppColors.light, Brightness.light);
  static ThemeData dark() => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors c, Brightness brightness) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: c.bg,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: c.primary,
        onPrimary: c.onPrimary,
        secondary: c.primary,
        onSecondary: c.onPrimary,
        error: c.wrongAnswer,
        onError: c.onPrimary,
        surface: c.surface,
        onSurface: c.text,
      ),
      textTheme: GoogleFonts.workSansTextTheme(base.textTheme).apply(
        bodyColor: c.text,
        displayColor: c.text,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.bg,
        foregroundColor: c.text,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(color: c.border),
        ),
      ),
      extensions: [c],
    );
  }
}
