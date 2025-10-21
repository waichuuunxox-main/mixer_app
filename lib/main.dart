import 'package:flutter/material.dart';
import 'package:mixzer_app/pages/home_page.dart';
import 'package:mixzer_app/services/cache_service.dart';
import 'package:mixzer_app/theme/macos_tahoe_theme.dart';

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
    return MaterialApp(
      title: 'Mixzer — Football',
      debugShowCheckedModeBanner: false,
      theme: MacosTahoeTheme.buildTheme(brightness: Brightness.light),
      home: const HomePage(),
    );
  }
}

