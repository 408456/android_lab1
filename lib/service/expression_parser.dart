import '../exception/calculator_exception.dart';

class ExpressionParser {
  String _expression = '';
  int _position = 0;

  double evaluate(String expression) {
    _expression = expression
        .replaceAll(' ', '')
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-');

    _position = 0;

    _validateExpression();

    final result = _parseExpression();

    if (_position < _expression.length) {
      throw CalculatorException(
        'некорректное выражение: ${_expression[_position]}',
      );
    }

    return result;
  }

  void _validateExpression() {
    if (_expression.isEmpty) {
      throw CalculatorException('пустое выражение');
    }

    if (_isOperator(_expression[_expression.length - 1])) {
      throw CalculatorException('выражение заканчивается оператором');
    }

    int openingBrackets = 0;
    int closingBrackets = 0;

    for (int i = 0; i < _expression.length; i++) {
      final character = _expression[i];

      if (character == '(') {
        openingBrackets++;

        if (i > 0) {
          final previous = _expression[i - 1];

          if (_isDigit(previous) || previous == ')') {
            throw CalculatorException(
              'перед открывающей скобкой должен быть оператор',
            );
          }
        }
      }

      if (character == ')') {
        closingBrackets++;

        if (closingBrackets > openingBrackets) {
          throw CalculatorException('неправильные скобки');
        }

        if (i == 0) {
          throw CalculatorException('неправильные скобки');
        }

        final previous = _expression[i - 1];

        if (_isOperator(previous) || previous == '(') {
          throw CalculatorException('неправильные скобки');
        }
      }

      if (_isOperator(character)) {
        if (i > 0 && _isOperator(_expression[i - 1])) {
          throw CalculatorException('два арифметических оператора подряд');
        }
      }
    }

    if (openingBrackets != closingBrackets) {
      throw CalculatorException('неправильные скобки');
    }
  }

  double _parseExpression() {
    double result = _parseTerm();

    while (_position < _expression.length) {
      final operator = _expression[_position];

      if (operator == '+') {
        _position++;
        result += _parseTerm();
      } else if (operator == '-') {
        _position++;
        result -= _parseTerm();
      } else {
        break;
      }
    }

    return result;
  }

  double _parseTerm() {
    double result = _parseFactor();

    while (_position < _expression.length) {
      final operator = _expression[_position];

      if (operator == '*') {
        _position++;
        result *= _parseFactor();
      } else if (operator == '/') {
        _position++;

        final divisor = _parseFactor();

        if (divisor == 0) {
          throw CalculatorException('деление на ноль');
        }

        result /= divisor;
      } else {
        break;
      }
    }

    return result;
  }

  double _parseFactor() {
    if (_position >= _expression.length) {
      throw CalculatorException('ожидалось число');
    }

    if (_expression[_position] == '-') {
      _position++;
      return -_parseFactor();
    }

    if (_expression[_position] == '(') {
      _position++;

      if (_position < _expression.length && _expression[_position] == ')') {
        throw CalculatorException('пустые скобки недопустимы');
      }

      final result = _parseExpression();

      if (_position >= _expression.length || _expression[_position] != ')') {
        throw CalculatorException('неправильные скобки');
      }

      _position++;

      return result;
    }

    if (_expression[_position] == ')') {
      throw CalculatorException('неправильные скобки');
    }

    return _parseNumber();
  }

  double _parseNumber() {
    final start = _position;
    bool hasDot = false;

    while (_position < _expression.length) {
      final character = _expression[_position];

      if (character == '.') {
        if (hasDot) {
          throw CalculatorException('в одном числе несколько десятичных точек');
        }

        hasDot = true;
        _position++;
      } else if (_isDigit(character)) {
        _position++;
      } else {
        break;
      }
    }

    if (start == _position) {
      throw CalculatorException('ожидалось число');
    }

    final numberText = _expression.substring(start, _position);

    try {
      return double.parse(numberText);
    } catch (_) {
      throw CalculatorException('некорректное число: $numberText');
    }
  }

  bool _isDigit(String character) {
    return character.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
        character.codeUnitAt(0) <= '9'.codeUnitAt(0);
  }

  bool _isOperator(String character) {
    return character == '+' ||
        character == '-' ||
        character == '*' ||
        character == '/';
  }
}
