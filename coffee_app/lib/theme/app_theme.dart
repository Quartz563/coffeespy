import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'coffee_spy_colors.dart';

class AppTheme {
  AppTheme._();

  static const bgDark = Color(0xFF191410);
  static const inkDark = Color(0xFFEFE6D6);
  static const bgLight = Color(0xFFECE6D8);
  static const inkLight = Color(0xFF1B1712);

  static ThemeData dark() => _build(
    brightness: Brightness.dark,
    bg: bgDark,
    ink: inkDark,
    colors: CoffeeSpyColors.dark,
  );

  static ThemeData light() => _build(
    brightness: Brightness.light,
    bg: bgLight,
    ink: inkLight,
    colors: CoffeeSpyColors.light,
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color bg,
    required Color ink,
    required CoffeeSpyColors colors,
  }) {
    final base = ThemeData(brightness: brightness, useMaterial3: true);

    final textTheme = GoogleFonts.hankenGroteskTextTheme(base.textTheme)
        .copyWith(
          displayLarge: GoogleFonts.newsreader(
            fontSize: 33,
            fontWeight: FontWeight.w600,
            letterSpacing: -1,
            color: ink,
          ),
          displayMedium: GoogleFonts.newsreader(
            fontSize: 27,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
            color: ink,
          ),
          headlineMedium: GoogleFonts.newsreader(
            fontSize: 19,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.2,
            color: ink,
          ),
          headlineSmall: GoogleFonts.newsreader(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: ink,
          ),
        )
        .apply(bodyColor: ink, displayColor: ink);

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      cardColor: colors.card,
      dividerColor: colors.line,
      textTheme: textTheme,
      colorScheme: base.colorScheme.copyWith(
        brightness: brightness,
        primary: colors.accent,
        onPrimary: colors.accentInk,
        surface: bg,
        onSurface: ink,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        foregroundColor: ink,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: colors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: colors.line),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor: colors.accentInk,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: GoogleFonts.hankenGrotesk(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: colors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: colors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(color: colors.accent),
        ),
      ),
      drawerTheme: DrawerThemeData(backgroundColor: bg),
      extensions: [colors],
    );
  }
}
