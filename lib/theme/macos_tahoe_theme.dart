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
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: mutedText,
        indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 2.5, color: colorScheme.primary)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        contentTextStyle: TextStyle(color: mutedText),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colorScheme.primary),
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
      ).copyWith(
        displayLarge: base.textTheme.displayLarge?.copyWith(fontSize: 40, fontWeight: FontWeight.w900),
        headlineLarge: base.textTheme.headlineLarge?.copyWith(fontSize: 26, fontWeight: FontWeight.w800),
        headlineMedium: base.textTheme.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      // small, soft shadows for macOS-like feel
      shadowColor: Colors.black.withAlpha(16), // adjusted shadow color
      // glamorous gradient tokens
      extensions: <ThemeExtension<dynamic>>[
        GlamTokens(
          gradientStart: Color(0xFF0FB1D2), // brighter cyan
          gradientEnd: Color(0xFF8BE8FF), // icy highlight
          glowColor: Color(0xFF8BE8FF),
          glowIntensity: 0.18,
        ),
      ],
    );
  }

  static GlamTokens glamTokensOf(BuildContext context) {
    final ext = Theme.of(context).extension<GlamTokens>();
    return ext ?? const GlamTokens(gradientStart: primary, gradientEnd: accent);
  }
}

class GlamTokens extends ThemeExtension<GlamTokens> {
  final Color gradientStart;
  final Color gradientEnd;
  final Color glowColor;
  final double glowIntensity;

  const GlamTokens({required this.gradientStart, required this.gradientEnd, this.glowColor = const Color(0xFF8BE8FF), this.glowIntensity = 0.08});

  @override
  GlamTokens copyWith({Color? gradientStart, Color? gradientEnd, Color? glowColor, double? glowIntensity}) => GlamTokens(
        gradientStart: gradientStart ?? this.gradientStart,
        gradientEnd: gradientEnd ?? this.gradientEnd,
        glowColor: glowColor ?? this.glowColor,
        glowIntensity: glowIntensity ?? this.glowIntensity,
      );

  @override
  GlamTokens lerp(ThemeExtension<GlamTokens>? other, double t) {
    if (other is! GlamTokens) return this;
    return GlamTokens(
      gradientStart: Color.lerp(gradientStart, other.gradientStart, t)!,
      gradientEnd: Color.lerp(gradientEnd, other.gradientEnd, t)!,
  glowColor: Color.lerp(glowColor, other.glowColor, t)!,
  glowIntensity: (glowIntensity + (other.glowIntensity - glowIntensity) * t),
    );
  }
}
