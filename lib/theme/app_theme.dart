import 'package:flutter/material.dart';

class AppColors {
  static const Color accent =
      Color(0xFF4F46E5);
  static const Color accentLight =
      Color(0xFFEEF2FF); 

  static const Color safe =
      Color(0xFF16A34A); 
  static const Color warning =
      Color(0xFFCA8A04); 
  static const Color danger =
      Color(0xFFEA580C); 
  static const Color critical =
      Color(0xFFDC2626); 

  static const List<Color> courseColors = [
    Color(0xFF6366F1), 
    Color(0xFF0EA5E9), 
    Color(0xFF10B981),
    Color(0xFFF59E0B), 
    Color(0xFFEC4899), 
    Color(0xFF8B5CF6), 
    Color(0xFF14B8A6), 
    Color(0xFFF97316), 
    Color(0xFF64748B), 
    Color(0xFFEF4444), 
  ];

  static Color courseColor(int index) =>
      courseColors[index % courseColors.length];

  static const Color darkBg =
      Color(0xFF0F0F0F);
  static const Color darkSurface =
      Color(0xFF1A1A1A);
  static const Color darkSurface2 =
      Color(0xFF242424);
  static const Color darkBorder =
      Color(0xFF2E2E2E);
  static const Color darkText =
      Color(0xFFF5F5F5);
  static const Color darkTextMuted =
      Color(0xFF888888);

  static const Color lightBg = Color(0xFFF8F8F8);
  static const Color lightSurface =
      Color(0xFFFFFFFF);
  static const Color lightSurface2 =
      Color(0xFFF1F1F1);
  static const Color lightBorder =
      Color(0xFFE5E5E5);
  static const Color lightText =
      Color(0xFF111111);
  static const Color lightTextMuted =
      Color(0xFF888888);
}

ThemeData buildTheme({required bool isDark}) {
  final bg = isDark
      ? AppColors.darkBg
      : AppColors.lightBg;
  final surface = isDark
      ? AppColors.darkSurface
      : AppColors.lightSurface;
  final surface2 = isDark
      ? AppColors.darkSurface2
      : AppColors.lightSurface2;
  final border = isDark
      ? AppColors.darkBorder
      : AppColors.lightBorder;
  final textColor = isDark
      ? AppColors.darkText
      : AppColors.lightText;
  final muted = isDark
      ? AppColors.darkTextMuted
      : AppColors.lightTextMuted;

  return ThemeData(
    useMaterial3: true,
    brightness: isDark
        ? Brightness.dark
        : Brightness.light,
    scaffoldBackgroundColor: bg,

    colorScheme: ColorScheme(
      brightness: isDark
          ? Brightness.dark
          : Brightness.light,
      primary: AppColors.accent,
      onPrimary: Colors.white,
      secondary: AppColors.accent,
      onSecondary: Colors.white,
      error: AppColors.critical,
      onError: Colors.white,
      surface: surface,
      onSurface: textColor,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: border, width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
            color: AppColors.accent, width: 1.5),
      ),
      labelStyle:
          TextStyle(color: muted, fontSize: 14),
      hintStyle:
          TextStyle(color: muted, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
    ),

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: StadiumBorder(),
    ),

    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: border),
      ),
      titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 17,
          fontWeight: FontWeight.w700),
      contentTextStyle:
          TextStyle(color: muted, fontSize: 14),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24)),
        side: BorderSide(color: border),
      ),
    ),

    dividerTheme: DividerThemeData(
        color: border, thickness: 1, space: 1),

    textTheme: TextTheme(
      headlineSmall: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 22,
          letterSpacing: -0.5),
      titleLarge: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 18,
          letterSpacing: -0.3),
      titleMedium: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 15),
      titleSmall: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 13),
      bodyMedium: TextStyle(
          color: textColor, fontSize: 14),
      bodySmall:
          TextStyle(color: muted, fontSize: 12),
      labelSmall:
          TextStyle(color: muted, fontSize: 11),
    ),
  );
}
