import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Colors pulled directly from your web app's style.css :root variables
// (light mode block) so the Flutter app matches exactly instead of guessing.
class AppColors {
  static const primary = Color(0xFFC97D60);       // --primary: terracotta / rose gold
  static const primaryLight = Color(0xFFFADCD1);   // --primary-light
  static const primaryHover = Color(0xFFB0684C);   // --primary-hover
  static const gold = Color(0xFFD4AF37);           // --accent: warm gold
  static const goldTint = Color(0xFFFEF5D8);       // --accent-light
  static const background = Color(0xFFFCFBFA);     // --bg-primary
  static const backgroundSecondary = Color(0xFFF4F0EC); // --bg-secondary
  static const cardBg = Colors.white;
  static const textDark = Color(0xFF2D2621);       // --text-primary
  static const textSecondary = Color(0xFF6E6055);  // --text-secondary
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFF9A825);
  static const danger = Color(0xFFC62828);
}

// Dark mode, pulled from your style.css .dark-mode block — used automatically
// when the phone's system theme is set to dark (see main.dart themeMode).
class AppColorsDark {
  static const primary = Color(0xFFD98C6C);
  static const primaryTint = Color(0xFF3D2218);
  static const background = Color(0xFF12100E);
  static const backgroundSecondary = Color(0xFF1A1614);
  static const cardBg = Color(0xFF1A1614);
  static const textPrimary = Color(0xFFF3EFE9);
  static const textSecondary = Color(0xFFB2A195);
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      background: AppColors.background,
      brightness: Brightness.light,
    ),
    fontFamily: GoogleFonts.outfit().fontFamily,
    textTheme: GoogleFonts.outfitTextTheme(),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBg,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
  );
}

ThemeData buildAppDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColorsDark.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColorsDark.primary,
      primary: AppColorsDark.primary,
      background: AppColorsDark.background,
      brightness: Brightness.dark,
    ),
    fontFamily: GoogleFonts.outfit().fontFamily,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme)
        .apply(bodyColor: AppColorsDark.textPrimary, displayColor: AppColorsDark.textPrimary),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColorsDark.background,
      foregroundColor: AppColorsDark.textPrimary,
      elevation: 0,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: AppColorsDark.textPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColorsDark.cardBg,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColorsDark.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColorsDark.backgroundSecondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
  );
}
