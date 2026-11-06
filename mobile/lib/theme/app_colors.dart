import 'package:flutter/material.dart';

/// Design tokens from the Ayaqli design handoff (Claude Design export).
class AppColors extends ThemeExtension<AppColors> {
  final Color bg;
  final Color surface;
  final Color surfaceAlt;
  final Color border;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color primary;
  final Color primaryDark;
  final Color primarySoft;
  final Color onPrimary;
  final Color wrongAnswer;

  const AppColors({
    required this.bg,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.primary,
    required this.primaryDark,
    required this.primarySoft,
    required this.onPrimary,
    required this.wrongAnswer,
  });

  static const light = AppColors(
    bg: Color(0xFFF6F4EC),
    surface: Color(0xFFFFFFFF),
    surfaceAlt: Color(0xFFEEEAE0),
    border: Color(0x1F122E29),
    text: Color(0xFF14312B),
    textMuted: Color(0x9E14302A),
    textFaint: Color(0x6114302A),
    primary: Color(0xFF0F6D5C),
    primaryDark: Color(0xFF0B4F43),
    primarySoft: Color(0x1A0F6D5C),
    onPrimary: Color(0xFFFBFAF6),
    wrongAnswer: Color(0xFFB3492E),
  );

  static const dark = AppColors(
    bg: Color(0xFF081E1A),
    surface: Color(0xFF0E2A25),
    surfaceAlt: Color(0xFF123330),
    border: Color(0x1FEAF3F0),
    text: Color(0xFFEAF3F0),
    textMuted: Color(0x9EEAF3F0),
    textFaint: Color(0x61EAF3F0),
    primary: Color(0xFF45B096),
    primaryDark: Color(0xFF2C7A65),
    primarySoft: Color(0x2945B096),
    onPrimary: Color(0xFF04140F),
    wrongAnswer: Color(0xFFB3492E),
  );

  @override
  AppColors copyWith({
    Color? bg,
    Color? surface,
    Color? surfaceAlt,
    Color? border,
    Color? text,
    Color? textMuted,
    Color? textFaint,
    Color? primary,
    Color? primaryDark,
    Color? primarySoft,
    Color? onPrimary,
    Color? wrongAnswer,
  }) {
    return AppColors(
      bg: bg ?? this.bg,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      border: border ?? this.border,
      text: text ?? this.text,
      textMuted: textMuted ?? this.textMuted,
      textFaint: textFaint ?? this.textFaint,
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primarySoft: primarySoft ?? this.primarySoft,
      onPrimary: onPrimary ?? this.onPrimary,
      wrongAnswer: wrongAnswer ?? this.wrongAnswer,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bg: Color.lerp(bg, other.bg, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      text: Color.lerp(text, other.text, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      textFaint: Color.lerp(textFaint, other.textFaint, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primarySoft: Color.lerp(primarySoft, other.primarySoft, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      wrongAnswer: Color.lerp(wrongAnswer, other.wrongAnswer, t)!,
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
