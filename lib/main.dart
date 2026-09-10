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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'Лабораторная работа №1',
      home: const CalculatorScreen(),
    );
  }
}