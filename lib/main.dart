import 'package:flutter/material.dart';
import 'package:mixzer_app/pages/home_page.dart';
import 'package:mixzer_app/services/cache_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CacheService.init().then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Stronger brand color and refined typography
    final Color seed = const Color(0xFF0D47A1); // deep indigo-blue

    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light),
      useMaterial3: true,
      fontFamily: 'NotoSans',
    );

    // Use system fonts to avoid runtime network font fetches which can fail in
    // restricted environments. This avoids google_fonts package attempting
    // background downloads that may throw async exceptions.
    final textTheme = base.textTheme.apply(
      bodyColor: Colors.grey[900],
      displayColor: Colors.grey[900],
    );

    return MaterialApp(
      title: 'Mixzer — Football',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: textTheme,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: seed,
          foregroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        // cardTheme removed for SDK compatibility; rely on Card widgets' local styling
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: seed,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 1,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: const HomePage(),
    );
  }
}

