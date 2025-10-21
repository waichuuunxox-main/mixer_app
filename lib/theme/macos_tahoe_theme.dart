import 'package:flutter/material.dart';

class MacosTahoeTheme {
  // Tahoe-inspired palette (muted blues/teals, soft neutrals)
  static const Color primary = Color(0xFF0A4E6A);
  static const Color accent = Color(0xFF2EA3B5);
  static const Color surface = Color(0xFFF6F7F9);
  static const Color elevated = Color(0xFFFFFFFF);
  static const Color mutedText = Color(0xFF4B5563);

  static ThemeData buildTheme({Brightness brightness = Brightness.light}) {
    final base = ThemeData(
      brightness: brightness,
      useMaterial3: true,
      fontFamily: 'NotoSans',
    );

      final colorScheme = ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: Colors.white,
        secondary: accent,
        onSecondary: Colors.white,
        error: Colors.red.shade700,
        onError: Colors.white,
        surface: surface,
        onSurface: mutedText,
      );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: surface,
      cardTheme: CardThemeData(
        color: elevated,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      appBarTheme: AppBarTheme(
          backgroundColor: primary, // use solid primary color for app bar
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: false,
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: mutedText,
        displayColor: mutedText,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      // small, soft shadows for macOS-like feel
      shadowColor: Colors.black.withAlpha(16), // adjusted shadow color
    );
  }
}
