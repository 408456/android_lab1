import 'package:flutter/material.dart';

import '../service/expression_parser.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '';
  String result = '';

  final ExpressionParser parser = ExpressionParser();

  void onButtonPressed(String button) {
    if (_isDigit(button)) {
      setState(() {
        expression += button;
      });
      return;
    }

    if (button == '.') {
      if (_canAddDecimalPoint()) {
        setState(() {
          expression += button;
        });
      }
      return;
    }

    if (button == '(') {
      if (_canAddOpeningBracket()) {
        setState(() {
          expression += button;
        });
      }
      return;
    }

    if (button == ')') {
      if (_canAddClosingBracket()) {
        setState(() {
          expression += button;
        });
      }
      return;
    }

    if (_isOperator(button)) {
      if (_canAddOperator()) {
        setState(() {
          expression += button;
        });
      }
    }
  }

  void calculate() {
    try {
      final value = parser.evaluate(expression);

      setState(() {
        result = value.toString();
      });
    } catch (e) {
      setState(() {
        result = 'Ошибка';
      });
    }
  }

  void percent() {
    if (expression.isEmpty) {
      return;
    }

    final last = expression[expression.length - 1];

    if (_isOperator(last) || last == '(') {
      return;
    }

    setState(() {
      int start = expression.length - 1;

      while (start >= 0 &&
          (_isDigit(expression[start]) || expression[start] == '.')) {
        start--;
      }

      final number = expression.substring(start + 1);

      final value = double.parse(number) / 100;

      expression = expression.substring(0, start + 1) + value.toString();
    });
  }

  void changeSign() {
    if (expression.isEmpty) {
      return;
    }

    final last = expression[expression.length - 1];

    if (_isOperator(last) || last == '(') {
      return;
    }

    setState(() {
      int start = expression.length - 1;

      while (start >= 0 &&
          (_isDigit(expression[start]) || expression[start] == '.')) {
        start--;
      }

      final number = expression.substring(start + 1);

      if (start >= 0 && expression[start] == '-') {
        expression = expression.substring(0, start) + number;
      } else {
        expression = expression.substring(0, start + 1) + '-' + number;
      }
    });
  }

  void clear() {
    setState(() {
      expression = '';
      result = '';
    });
  }

  void backspace() {
    if (expression.isEmpty) {
      return;
    }

    setState(() {
      expression = expression.substring(0, expression.length - 1);
    });
  }

  bool _isDigit(String button) {
    return button.length == 1 &&
        button.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
        button.codeUnitAt(0) <= '9'.codeUnitAt(0);
  }

  bool _isOperator(String button) {
    return button == '+' || button == '−' || button == '×' || button == '÷';
  }

  bool _canAddOperator() {
    if (expression.isEmpty) {
      return false;
    }

    if (_isOperator(expression[expression.length - 1])) {
      return false;
    }

    if (expression.endsWith('(')) {
      return false;
    }

    return true;
  }

  bool _canAddDecimalPoint() {
    if (expression.isEmpty) {
      return true;
    }

    if (_isOperator(expression[expression.length - 1])) {
      return true;
    }

    if (expression.endsWith('(')) {
      return true;
    }

    int start = expression.length - 1;

    while (start >= 0 && !_isOperator(expression[start])) {
      if (expression[start] == '(') {
        break;
      }

      start--;
    }

    final currentNumber = expression.substring(start + 1);

    return !currentNumber.contains('.');
  }

  bool _canAddOpeningBracket() {
    if (expression.isEmpty) {
      return true;
    }

    final last = expression[expression.length - 1];

    if (_isDigit(last) || last == ')') {
      return false;
    }

    return true;
  }

  bool _canAddClosingBracket() {
    if (expression.isEmpty) {
      return false;
    }

    final last = expression[expression.length - 1];

    if (_isOperator(last) || last == '(') {
      return false;
    }

    int opening = 0;
    int closing = 0;

    for (final character in expression.split('')) {
      if (character == '(') {
        opening++;
      } else if (character == ')') {
        closing++;
      }
    }

    return opening > closing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('android_lab1')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      expression.isEmpty ? '0' : expression,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      result,
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  buildButtonRow(['M+', 'M−', 'MR', 'MC']),
                  buildButtonRow(['C', '⌫', '(', ')']),
                  buildButtonRow(['7', '8', '9', '÷']),
                  buildButtonRow(['4', '5', '6', '×']),
                  buildButtonRow(['1', '2', '3', '−']),
                  buildButtonRow(['0', '.', '%', '+']),
                  buildButtonRow(['±', '=', '', '']),
                ],
              ),
            ),
          ],
        ),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onPressed: button.isEmpty
                    ? null
                    : () {
                        if (button == '=') {
                          calculate();
                        } else if (button == 'C') {
                          clear();
                        } else if (button == '⌫') {
                          backspace();
                        } else if (button == '±') {
                          changeSign();
                        } else if (button == '%') {
                          percent();
                        } else {
                          onButtonPressed(button);
                        }
                      },
                child: Text(button, style: const TextStyle(fontSize: 20)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
