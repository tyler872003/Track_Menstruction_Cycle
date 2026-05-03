import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary palette (rose/pink)
  static const Color primary = Color(0xFF864E5A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFFFB7C5);
  static const Color onPrimaryContainer = Color(0xFF7B4551);
  static const Color primaryFixed = Color(0xFFFFD9DF);
  static const Color primaryFixedDim = Color(0xFFFBB3C1);

  // Secondary palette (purple/lavender)
  static const Color secondary = Color(0xFF625981);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFDACEFD);
  static const Color onSecondaryContainer = Color(0xFF5F567E);
  static const Color secondaryFixed = Color(0xFFE7DEFF);
  static const Color secondaryFixedDim = Color(0xFFCCC0EE);

  // Tertiary palette (warm orange/peach)
  static const Color tertiary = Color(0xFF7C5546);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFFF2BFAD);
  static const Color onTertiaryContainer = Color(0xFF724C3E);
  static const Color tertiaryFixed = Color(0xFFFFDBCE);
  static const Color tertiaryFixedDim = Color(0xFFEEBBA9);

  // Surface palette
  static const Color background = Color(0xFFFEF8F8);
  static const Color surface = Color(0xFFFEF8F8);
  static const Color surfaceBright = Color(0xFFFEF8F8);
  static const Color surfaceDim = Color(0xFFDED9D9);
  static const Color surfaceContainer = Color(0xFFF2ECED);
  static const Color surfaceContainerLow = Color(0xFFF8F2F2);
  static const Color surfaceContainerHigh = Color(0xFFECE7E7);
  static const Color surfaceContainerHighest = Color(0xFFE7E1E1);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);

  // On-surface palette
  static const Color onSurface = Color(0xFF1D1B1B);
  static const Color onSurfaceVariant = Color(0xFF514345);
  static const Color onBackground = Color(0xFF1D1B1B);

  // Outline palette
  static const Color outline = Color(0xFF837375);
  static const Color outlineVariant = Color(0xFFD6C2C4);

  // Error palette
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color onErrorContainer = Color(0xFF93000A);

  // Surface variant
  static const Color surfaceVariant = Color(0xFFE7E1E1);

  // OnTertiary fixed
  static const Color onTertiaryFixed = Color(0xFF2F1409);

  // Special
  static const Color inverseSurface = Color(0xFF323030);
  static const Color inverseOnSurface = Color(0xFFF5EFEF);
  static const Color inversePrimary = Color(0xFFFBB3C1);

  // Pink aliases for bottom nav
  static const Color pinkLight = Color(0xFFFFB7C5);
  static const Color pinkActive = Color(0xFFE91E63);
}

class AppTheme {
  static ThemeData get lightTheme {
    final ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
      inversePrimary: AppColors.inversePrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontSize: 40, fontWeight: FontWeight.w700, letterSpacing: -0.02 * 40),
          displayMedium: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          displaySmall: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
          headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, height: 1.6),
          bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
          bodySmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 0.01 * 14),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white.withOpacity(0.7),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFEC407A),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFFFB7C5)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceContainerLow,
        selectedColor: AppColors.primaryFixed,
        labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w500),
        shape: const StadiumBorder(),
        side: BorderSide(color: AppColors.outline, width: 1),
      ),
      cardTheme: CardTheme(
        elevation: 0,
        color: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLow,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: TextStyle(color: AppColors.outline),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white.withOpacity(0.85),
        indicatorColor: AppColors.primaryFixed.withOpacity(0.5),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary);
          }
          return GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.primaryFixed);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary);
          }
          return const IconThemeData(color: AppColors.primaryFixedDim);
        }),
        elevation: 0,
      ),
    );
  }
}
