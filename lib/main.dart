import 'package:flutter/material.dart';

import 'ui/calculator_screen.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Android-IOS. Лабораторная работа №1. Гольцман Глеб 408456',

      theme: ThemeData(
        brightness: Brightness.light,

        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
        ),
      ),

      home: const CalculatorScreen(),
    );
  }
}
