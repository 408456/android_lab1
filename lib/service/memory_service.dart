class CalculationHistoryItem {
  final String expression;
  final String result;

  CalculationHistoryItem({required this.expression, required this.result});
}


class CalculatorMemory {
  double _value = 0;

  double get value => _value;

  void add(double value) {
    _value += value;
  }

  void subtract(double value) {
    _value -= value;
  }

  void clear() {
    _value = 0;
  }
}

class CalculatorHistory {
  static const int maxItems = 10;
  final List<CalculationHistoryItem> _items = [];
  List<CalculationHistoryItem> get items => List.unmodifiable(_items);

  void add(String expression, String result) {
    _items.insert(
      0,
      CalculationHistoryItem(
        expression: expression,
        result: result,
      ),
    );

    if (_items.length > maxItems) {
      _items.removeLast();
    }
  }
}