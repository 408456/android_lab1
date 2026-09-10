import 'package:android_lab1/service/calculator_service.dart';
import 'package:flutter/material.dart';

import '../exception/calculator_exception.dart';
import '../service/expression_parser.dart';
import '../service/memory_service.dart';
import '../utils/calculator_logger.dart';
import 'calculator_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorLogger logger = CalculatorLogger();

  late final CalculatorService calculator;
  final CalculatorMemory memory = CalculatorMemory();
  final CalculatorHistory history = CalculatorHistory();

  @override
  void initState() {
    super.initState();

    calculator = CalculatorService(ExpressionParser());
  }

  void onButtonPressed(String button) {
    switch (button) {
      case '=':
        calculate();
        break;

      case 'C':
        calculator.clear();
        setState(() {});
        break;

      case '⌫':
        calculator.backspace();
        setState(() {});
        break;

      case '±':
        calculator.changeSign();
        setState(() {});
        break;

      case '%':
        calculator.percent();
        setState(() {});
        break;

      case 'M+':
        memoryAdd();
        break;

      case 'M−':
        memorySubtract();
        break;

      case 'MR':
        memoryRecall();
        break;

      case 'MC':
        memoryClear();
        break;

      default:
        calculator.press(button);
        setState(() {});
    }
  }

  void calculate() {
    logger.logAction('вычисление: ${calculator.expression}');

    try {
      final value = calculator.calculate();
      history.add(calculator.expression, value.toString());
      setState(() {});

    } on CalculatorException catch (e) {
      calculator.result = e.message;
      setState(() {});

      logger.logError(
        'ошибка "${calculator.expression}": ${e.message}',
      );

    } catch (e) {
      calculator.result = 'неизвестная ошибка';
      setState(() {});
      logger.logError('неизвестная ошибка "${calculator.expression}": $e');
    }
  }

  void memoryAdd() {
    final value = double.tryParse(calculator.result);

    if (value == null) {
      return;
    }

    memory.add(value);
    logger.logAction('M+: ${memory.value}');
  }

  void memorySubtract() {
    final value = double.tryParse(calculator.result);

    if (value == null) {
      return;
    }

    memory.subtract(value);
    logger.logAction('M−: ${memory.value}');
  }

  void memoryRecall() {
    calculator.expression = memory.value.toString();
    calculator.result = '';
    setState(() {});
    logger.logAction('MR: ${memory.value}');
  }

  void memoryClear() {
    memory.clear();
    logger.logAction('MC: память очищена');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('408456 android_lab1')),
      body: SafeArea(
        child: Column(
          children: [buildHistory(), buildDisplay(), buildKeyboard()],
        ),
      ),
    );
  }

  Widget buildHistory() {
    if (history.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          SizedBox(
            height: 90,
            child: ListView.builder(
              itemCount: history.items.length,
              itemBuilder: (context, index) {
                final item = history.items[index];

                return InkWell(
                  onTap: () {
                    calculator.expression = item.expression;
                    calculator.result = '';

                    setState(() {});

                    logger.logAction(
                      'из истории: ${item.expression}',
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.expression,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '= ${item.result}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
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
    );
  }

  Widget buildDisplay() {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        alignment: Alignment.bottomRight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              calculator.expression.isEmpty ? '0' : calculator.expression,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 10),
            Text(
              calculator.result,
              style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildKeyboard() {
    return Expanded(
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
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Expanded(
      child: Row(
        children: buttons.map((button) {
          return CalculatorButton(
            text: button,
            onPressed: button.isEmpty ? null : () => onButtonPressed(button),
          );
        }).toList(),
      ),
    );
  }
}
