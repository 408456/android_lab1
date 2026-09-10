import 'package:flutter_test/flutter_test.dart';

import '../lib/service/expression_parser.dart';

void main() {
  final parser = ExpressionParser();

  group('ExpressionParser', () {
    test('складывает два числа', () {
      expect(
        parser.evaluate('2+3'),
        5,
      );
    });

    test('учитывает приоритет умножения', () {
      expect(
        parser.evaluate('2+3*4'),
        14,
      );
    });

    test('учитывает приоритет деления', () {
      expect(
        parser.evaluate('20/4+7'),
        12,
      );
    });

    test('учитывает скобки', () {
      expect(
        parser.evaluate('(2+3)*4'),
        20,
      );
    });

    test('работает с несколькими операциями', () {
      expect(
        parser.evaluate('10+2*3-4/2'),
        14,
      );
    });

    test('работает с вещественными числами', () {
      expect(
        parser.evaluate('15.5*2'),
        31,
      );
    });

    test('работает со сложными скобками', () {
      expect(
        parser.evaluate('(12+5)*(3-1)'),
        34,
      );
    });

    test('выбрасывает ошибку при делении на ноль', () {
      expect(
            () => parser.evaluate('10/0'),
        throwsA(isA<FormatException>()),
      );
    });

    test('выбрасывает ошибку для пустого выражения', () {
      expect(
            () => parser.evaluate(''),
        throwsA(isA<FormatException>()),
      );
    });

    test('выбрасывает ошибку при неправильных скобках', () {
      expect(
            () => parser.evaluate('(2+3'),
        throwsA(isA<FormatException>()),
      );
    });
  });
}