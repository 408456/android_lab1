import 'dart:developer' as developer;

class CalculatorLogger {
  void logAction(String action) {
    developer.log(
      action,
      name: 'Calculator',
    );
  }

  void logError(String message) {
    developer.log(
      message,
      name: 'Calculator.Error',
      level: 1000,
    );
  }
}