import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bgBase,
      primaryColor: AppColors.accent,

      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        secondary: AppColors.accentDim,
        surface: AppColors.bgSurface,
        error: AppColors.danger,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),

      textTheme: _buildTextTheme(),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bgElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.danger),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontFamily: 'JetBrainsMono', fontSize: 13),
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontFamily: 'JetBrainsMono', fontSize: 12),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.black,
          disabledBackgroundColor: AppColors.bgElevated,
          disabledForegroundColor: AppColors.textMuted,
          textStyle: const TextStyle(
            fontFamily: 'JetBrainsMono',
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 2,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent),
          textStyle: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12, letterSpacing: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12),
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        elevation: 0,
        margin: const EdgeInsets.all(0),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bgSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.syne(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.accent,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 22),
        actionsIconTheme: const IconThemeData(color: AppColors.textSecondary),
      ),

      drawerTheme: const DrawerThemeData(
        backgroundColor: AppColors.bgSurface,
        scrimColor: Colors.black54,
        elevation: 0,
        width: 280,
      ),

      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.bgSurface,
        selectedIconTheme: IconThemeData(color: AppColors.accent),
        unselectedIconTheme: IconThemeData(color: AppColors.textSecondary),
        selectedLabelTextStyle: TextStyle(
          color: AppColors.accent,
          fontFamily: 'JetBrainsMono',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: TextStyle(
          color: AppColors.textSecondary,
          fontFamily: 'JetBrainsMono',
          fontSize: 11,
        ),
        indicatorColor: AppColors.accentGhost,
        elevation: 0,
        useIndicator: true,
      ),

      listTileTheme: const ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: AppColors.accentGhost,
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        dense: true,
      ),

      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 20),

      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.bgElevated,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: const TextStyle(color: AppColors.textPrimary, fontFamily: 'JetBrainsMono', fontSize: 11),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.bgElevated,
        contentTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'JetBrainsMono',
          fontSize: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.accent,
        linearTrackColor: AppColors.bgElevated,
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.accent;
          return AppColors.bgElevated;
        }),
        checkColor: WidgetStateProperty.all(Colors.black),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.black;
          return AppColors.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.accent;
          return AppColors.bgElevated;
        }),
      ),

      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.accent,
        inactiveTrackColor: AppColors.bgElevated,
        thumbColor: AppColors.accent,
        overlayColor: AppColors.accentGhost,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.bgElevated,
        selectedColor: AppColors.accentGhost,
        labelStyle: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 11, color: AppColors.textSecondary),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    const monoFont = 'JetBrainsMono';

    return TextTheme(
      // Display
      displayLarge: GoogleFonts.syne(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 2),
      displayMedium: GoogleFonts.syne(fontSize: 26, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 1.5),
      displaySmall: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 1),

      // Headline
      headlineLarge: GoogleFonts.syne(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 1.5),
      headlineMedium: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 1),
      headlineSmall: GoogleFonts.syne(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),

      // Title
      titleLarge: const TextStyle(fontFamily: monoFont, fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
      titleMedium: const TextStyle(fontFamily: monoFont, fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
      titleSmall: const TextStyle(fontFamily: monoFont, fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 1.5),

      // Body
      bodyLarge: const TextStyle(fontFamily: monoFont, fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
      bodyMedium: const TextStyle(fontFamily: monoFont, fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textPrimary),
      bodySmall: const TextStyle(fontFamily: monoFont, fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.textSecondary),

      // Label
      labelLarge: const TextStyle(fontFamily: monoFont, fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary, letterSpacing: 1.5),
      labelMedium: const TextStyle(fontFamily: monoFont, fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary, letterSpacing: 1),
      labelSmall: const TextStyle(fontFamily: monoFont, fontSize: 10, fontWeight: FontWeight.w400, color: AppColors.textMuted, letterSpacing: 1),
    );
  }
}
