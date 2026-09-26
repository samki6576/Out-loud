import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum Season { spring, summer, autumn, winter }

class SeasonHelper {
  static Season getCurrentSeason() {
    final month = DateTime.now().month;
    if (month >= 3 && month <= 5) return Season.spring;
    if (month >= 6 && month <= 8) return Season.summer;
    if (month >= 9 && month <= 11) return Season.autumn;
    return Season.winter;
  }

  static String getSeasonName(Season season) {
    switch (season) {
      case Season.spring:
        return 'Spring';
      case Season.summer:
        return 'Summer';
      case Season.autumn:
        return 'Autumn';
      case Season.winter:
        return 'Winter';
    }
  }

  static IconData getSeasonIcon(Season season) {
    switch (season) {
      case Season.spring:
        return Icons.local_florist_rounded;
      case Season.summer:
        return Icons.wb_sunny_rounded;
      case Season.autumn:
        return Icons.eco_rounded;
      case Season.winter:
        return Icons.ac_unit_rounded;
    }
  }
}

class AppColors {
  // Backgrounds — light, airy
  static const bg = Color(0xFFF8F7FB);
  static const bgAlt = Color(0xFFF2F0F8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSoft = Color(0xFFF4F2FA);

  // Pastel accents
  static const sage = Color(0xFF8BC9A8);
  static const sageLight = Color(0xFFD4EAD9);
  static const lavender = Color(0xFFC8B8FF);
  static const lavenderLight = Color(0xFFE8E0FF);
  static const peach = Color(0xFFFFCFB5);
  static const sky = Color(0xFFB5D8F0);
  static const cherryBlossom = Color(0xFFFFD6E8);
  static const autumnGold = Color(0xFFF4A261);
  static const winterIce = Color(0xFFBEE3F8);

  // Text
  static const textPrimary = Color(0xFF2A2A3A);
  static const textSecondary = Color(0xFF6B6B85);
  static const textMuted = Color(0xFF9E9EB8);

  // UI
  static const border = Color(0xFFEBE9F2);
  static const danger = Color(0xFFFF8B8B);
}

class AppGradients {
  static LinearGradient getGradientForSeason(Season season) {
    switch (season) {
      case Season.spring:
        return const LinearGradient(
          colors: [Color(0xFFFFF0F5), Color(0xFFE8E0FF), Color(0xFFD4EAD9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case Season.summer:
        return const LinearGradient(
          colors: [Color(0xFFFFE5D6), Color(0xFFFFF1E8), Color(0xFFE8F4F8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case Season.autumn:
        return const LinearGradient(
          colors: [Color(0xFFFDF0ED), Color(0xFFFCE5CD), Color(0xFFF7E2D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case Season.winter:
        return const LinearGradient(
          colors: [Color(0xFFF0F4F8), Color(0xFFE2ECE9), Color(0xFFD8E2DC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  static const hero = LinearGradient(
    colors: [Color(0xFFE8E0FF), Color(0xFFD4EAD9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const background = LinearGradient(
    colors: [Color(0xFFF8F7FB), Color(0xFFF2F0F8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppText {
  static TextStyle h1 = GoogleFonts.inter(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMuted = GoogleFonts.inter(
    fontSize: 15,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 13,
    color: AppColors.textMuted,
    fontWeight: FontWeight.w500,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 12,
    color: AppColors.textMuted,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.light(
      primary: AppColors.sage,
      secondary: AppColors.lavender,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    textTheme: GoogleFonts.interTextTheme(base.textTheme),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: AppText.h3,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceSoft,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: AppText.bodyMuted.copyWith(color: AppColors.textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.sage, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.sage,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        elevation: 0,
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.sage,
      foregroundColor: Colors.white,
    ),
  );
}

final ThemeData appTheme = buildAppTheme();

/// Soft white card with gentle shadow — matches the reference image.
BoxDecoration softCard({Color? color, bool elevated = false}) {
  return BoxDecoration(
    color: color ?? AppColors.surface,
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: AppColors.lavender.withValues(alpha: elevated ? 0.18 : 0.08),
        blurRadius: elevated ? 24 : 16,
        offset: Offset(0, elevated ? 8 : 4),
      ),
    ],
  );
}

/// Custom smooth page transition with gentle fade and slide curve.
class CalmPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  CalmPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final fade = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            );
            final slide = Tween<Offset>(
              begin: const Offset(0.0, 0.04),
              end: Offset.zero,
            ).animate(fade);
            return FadeTransition(
              opacity: fade,
              child: SlideTransition(
                position: slide,
                child: child,
              ),
            );
          },
        );
}
