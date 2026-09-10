import 'package:flutter_test/flutter_test.dart';

import '../lib/exception/calculator_exception.dart';
import '../lib/service/expression_parser.dart';

void main() {
  group('ExpressionParser - обработка ошибок', () {
    late ExpressionParser parser;

    setUp(() {
      parser = ExpressionParser();
    });

    test('пустое выражение', () {
      expect(
            () => parser.evaluate(''),
        throwsA(
          isA<CalculatorException>().having(
                (error) => error.message,
            'message',
            'пустое выражение',
          ),
        ),
      );
    });

    test('деление на ноль', () {
      expect(
            () => parser.evaluate('10 / 0'),
        throwsA(
          isA<CalculatorException>().having(
                (error) => error.message,
            'message',
            'деление на ноль',
          ),
        ),
      );
    });

    test('два оператора подряд', () {
      expect(
            () => parser.evaluate('10 + * 5'),
        throwsA(
          isA<CalculatorException>().having(
                (error) => error.message,
            'message',
            'два арифметических оператора подряд',
          ),
        ),
      );
    });

    test('несколько десятичных точек', () {
      expect(
            () => parser.evaluate('10.5.2'),
        throwsA(
          isA<CalculatorException>().having(
                (error) => error.message,
            'message',
            'в одном числе несколько десятичных точек',
          ),
        ),
      );
    });

    test('выражение заканчивается оператором', () {
      expect(
            () => parser.evaluate('10 + 5 *'),
        throwsA(
          isA<CalculatorException>().having(
                (error) => error.message,
            'message',
            'выражение заканчивается оператором',
          ),
        ),
      );
    });

    test('незакрытая скобка', () {
      expect(
            () => parser.evaluate('(10 + 5'),
        throwsA(
          isA<CalculatorException>().having(
                (error) => error.message,
            'message',
            'неправильные скобки',
          ),
        ),
      );
    });

    test('лишняя закрывающая скобка', () {
      expect(
            () => parser.evaluate('10 + 5)'),
        throwsA(
          isA<CalculatorException>().having(
                (error) => error.message,
            'message',
            'неправильные скобки',
          ),
        ),
      );
    });

    test('пустые скобки', () {
      expect(
            () => parser.evaluate('()'),
        throwsA(
          isA<CalculatorException>().having(
                (error) => error.message,
            'message',
            'неправильные скобки',
          ),
        ),
      );
    });

    test('число сразу после закрывающей скобки', () {
      expect(
            () => parser.evaluate('(10 + 5)2'),
        throwsA(
          isA<CalculatorException>(),
        ),
      );
    });

    test('открывающая скобка после числа', () {
      expect(
            () => parser.evaluate('5(10 + 2)'),
        throwsA(
          isA<CalculatorException>().having(
                (error) => error.message,
            'message',
            'перед открывающей скобкой должен быть оператор',
          ),
        ),
      );
    });
  });
}