import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ExamsApp());
}

class ExamsApp extends StatelessWidget {
  const ExamsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Распоред за испити',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
