import 'package:flutter/material.dart';

import '../model/calculation_history.dart';
import '../exception/calculator_exception.dart';
import '../utils/calculator_logger.dart';
import '../service/expression_parser.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String expression = '';
  String result = '';
  double memory = 0;

  final ExpressionParser parser = ExpressionParser();
  final CalculatorLogger logger = CalculatorLogger();

  final List<CalculationHistoryItem> history = [];

  void onButtonPressed(String button) {
    if (_isDigit(button)) {
      setState(() {
        expression += button;
        result = '';
      });
      return;
    }

    if (button == '.') {
      if (_canAddDecimalPoint()) {
        setState(() {
          expression += button;
          result = '';
        });
      }
      return;
    }

    if (button == '(') {
      if (_canAddOpeningBracket()) {
        setState(() {
          expression += button;
          result = '';
        });
      }
      return;
    }

    if (button == ')') {
      if (_canAddClosingBracket()) {
        setState(() {
          expression += button;
          result = '';
        });
      }
      return;
    }

    if (_isOperator(button)) {
      if (_canAddOperator()) {
        setState(() {
          expression += button;
          result = '';
        });
      }
    }
  }

  void calculate() {
    logger.logAction('вычисление: $expression');

    try {
      final value = parser.evaluate(expression);
      final calculatedResult = value.toString();

      setState(() {
        result = calculatedResult;

        history.insert(
          0,
          CalculationHistoryItem(
            expression: expression,
            result: calculatedResult,
          ),
        );

        if (history.length > 10) {
          history.removeLast();
        }
      });
    } on CalculatorException catch (e) {
      setState(() {
        result = e.message;
      });

      logger.logError('ошибка вычисления "$expression": ${e.message}');
    } catch (e) {
      setState(() {
        result = 'неизвестная ошибка';
      });

      logger.logError('неизвестная ошибка "$expression": $e');
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

    try {
      setState(() {
        int start = expression.length - 1;

        while (start >= 0 &&
            (_isDigit(expression[start]) || expression[start] == '.')) {
          start--;
        }

        final number = expression.substring(start + 1);
        final value = double.parse(number) / 100;

        expression = expression.substring(0, start + 1) + value.toString();

        result = '';
      });
    } catch (e) {
      setState(() {
        result = 'некорректное число';
      });
    }
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

      result = '';
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
      result = '';
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

  void memoryAdd() {
    if (result.isEmpty) {
      return;
    }

    final value = double.tryParse(result);

    if (value == null) {
      return;
    }

    setState(() {
      memory += value;
    });

    logger.logAction('M+: $memory');
  }

  void memorySubtract() {
    if (result.isEmpty) {
      return;
    }

    final value = double.tryParse(result);

    if (value == null) {
      return;
    }

    setState(() {
      memory -= value;
    });

    logger.logAction('M−: $memory');
  }

  void memoryRecall() {
    setState(() {
      expression = memory.toString();
      result = '';
    });

    logger.logAction('MR: $memory');
  }

  void memoryClear() {
    setState(() {
      memory = 0;
    });

    logger.logAction('MC: память очищена');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('android_lab1')),
      body: SafeArea(
        child: Column(
          children: [
            if (history.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 90,
                      child: ListView.builder(
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          final item = history[index];

                          return InkWell(
                            onTap: () {
                              setState(() {
                                expression = item.expression;
                                result = '';
                              });

                              logger.logAction(
                                'выбрано выражение из истории: ${item.expression}',
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.expression,
                                      style: const TextStyle(fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '= ${item.result}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ),
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
                        } else if (button == 'M+') {
                          memoryAdd();
                        } else if (button == 'M−') {
                          memorySubtract();
                        } else if (button == 'MR') {
                          memoryRecall();
                        } else if (button == 'MC') {
                          memoryClear();
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
