import 'package:flutter/material.dart';
import 'screens/category_list_screen.dart';

void main() {
  runApp(const MealApp());
}

class MealApp extends StatelessWidget {
  const MealApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
    );

    final theme = base.copyWith(
      scaffoldBackgroundColor: const Color(0xFFF7F3ED),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        titleSpacing: 16,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white70,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      textTheme: base.textTheme.apply(
        bodyColor: const Color(0xFF2C2C2C),
        displayColor: const Color(0xFF2C2C2C),
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        elevation: 4,
      ),
    );

    return MaterialApp(
      title: 'Meal Explorer',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const CategoryListScreen(),
    );
  }
}
