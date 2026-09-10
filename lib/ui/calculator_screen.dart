import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '';

  void onButtonPressed(String button) {
    setState(() {
      expression += button;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('android_lab1')),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(20),
              child: Text(
                expression.isEmpty ? '0' : expression,
                style: const TextStyle(fontSize: 48),
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Column(
              children: [
                buildButtonRow(['M+', 'M−', 'MR', 'MC']),
                buildButtonRow(['C', '<-', '(', ')']),
                buildButtonRow(['7', '8', '9', '/']),
                buildButtonRow(['4', '5', '6', '*']),
                buildButtonRow(['1', '2', '3', '−']),
                buildButtonRow(['0', '.', '%', '+']),
                buildButtonRow(['±', '=', '', '']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((button) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: ElevatedButton(
                onPressed: button.isEmpty
                    ? null
                    : () {
                        onButtonPressed(button);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  button,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
