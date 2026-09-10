import '../service/expression_parser.dart';

class CalculatorService {
  String expression = '';
  String result = '';

  final ExpressionParser parser;

  CalculatorService(this.parser);

  void press(String button) {
    if (_isDigit(button)) {
      expression += button;
      result = '';
      return;
    }

    if (button == '.') {
      if (_canAddDecimalPoint()) {
        expression += button;
        result = '';
      }
      return;
    }

    if (button == '(') {
      if (_canAddOpeningBracket()) {
        expression += button;
        result = '';
      }
      return;
    }

    if (button == ')') {
      if (_canAddClosingBracket()) {
        expression += button;
        result = '';
      }
      return;
    }

    if (_isOperator(button)) {
      if (_canAddOperator()) {
        expression += button;
        result = '';
      }
    }
  }

  double calculate() {
    final value = parser.evaluate(expression);
    result = value.toString();
    return value;
  }

  void clear() {
    expression = '';
    result = '';
  }

  void backspace() {
    if (expression.isEmpty) {
      return;
    }

    expression = expression.substring(0, expression.length - 1);

    result = '';
  }

  void percent() {
    if (expression.isEmpty) {
      return;
    }

    final last = expression[expression.length - 1];

    if (_isOperator(last) || last == '(') {
      return;
    }

    int start = expression.length - 1;

    while (start >= 0 &&
        (_isDigit(expression[start]) || expression[start] == '.')) {
      start--;
    }

    final number = expression.substring(start + 1);
    final value = double.parse(number) / 100;

    expression = expression.substring(0, start + 1) + value.toString();

    result = '';
  }

  void changeSign() {
    if (expression.isEmpty) {
      return;
    }

    final last = expression[expression.length - 1];

    if (_isOperator(last) || last == '(') {
      return;
    }

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
}
