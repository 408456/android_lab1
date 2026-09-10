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

    if (_expression.isEmpty) {
      throw FormatException('Пустое выражение');
    }

    final result = _parseExpression();

    if (_position < _expression.length) {
      throw FormatException(
        'Некорректное выражение: ${_expression[_position]}',
      );
    }

    return result;
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
          throw FormatException('Деление на ноль');
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
      throw FormatException('Ожидалось число');
    }

    if (_expression[_position] == '(') {
      _position++;

      final result = _parseExpression();

      if (_position >= _expression.length ||
          _expression[_position] != ')') {
        throw FormatException('Неправильные скобки');
      }

      _position++;

      return result;
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
          throw FormatException(
            'В одном числе несколько десятичных точек',
          );
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
      throw FormatException(
        'Ожидалось число',
      );
    }

    final numberText = _expression.substring(start, _position);

    return double.parse(numberText);
  }

  bool _isDigit(String character) {
    return character.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
        character.codeUnitAt(0) <= '9'.codeUnitAt(0);
  }
}