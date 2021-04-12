class CalculatorController {
  static const kZero = '0';
  static const kMemoryFirst = 0;
  static const kMemoryClear = [0.0, 0.0];
  static const kOperationNull = null;
  static const kPoint = ',';
  static const kEmpty = '';

  List<double> _memories = [0.0, 0.0];
  int _currentMemoryIndex = 0;
  String _operation;
  bool _usedOperation;
  String result;
  String operDisp;
  bool _usedEqual;

  CalculatorController() {
    clear();
  }

  void clear() {
    result = kZero;
    _memories.setAll(kMemoryFirst, kMemoryClear);
    _currentMemoryIndex = kMemoryFirst;
    _operation = kOperationNull;
    _usedOperation = false;
    operDisp = kEmpty;
    _usedEqual = false;
  }

  void deleteDigit() {
    final length = result.length;
    if (length > 1) {
      result = result.substring(0, length - 1);
    } else {
      result = kZero;
    }
    if (operDisp.length > 1) {
      operDisp = operDisp.substring(0, length - 1);
    } else {
      result = kZero;
    }
  }

  void addDigit(String digit) {
    if (_usedOperation) result = kZero;
    if (result == kZero && digit != kPoint) result = kEmpty;
    if (result.contains(kPoint) && digit == kPoint) digit = kEmpty;
    result += digit;
    operDisp += digit;

    _memories[_currentMemoryIndex] =
        double.parse(result.replaceAll(kPoint, '.'));
    _usedOperation = false;
  }

  void setOperation(String operation) {
    if (_usedOperation && _operation == operation) return;
    if (_currentMemoryIndex == kMemoryFirst) {
      _currentMemoryIndex++;
    } else if (!_usedEqual || (_usedEqual && operation == '=')) {
      _memories[kMemoryFirst] = calculate();
    }

    if (operation != '=') {
      _operation = operation;
      _usedEqual = false;
    } else {
      _usedEqual = true;
    }
    outputFormat();
    _usedOperation = true;
  }

  void outputFormat() {
    result = _memories[kMemoryFirst].toString();
    result = result.endsWith('.0') ? result.replaceAll('.0', '') : result;
    result = result.replaceAll('.', kPoint);
  }

  double calculate() {
    if (_operation == '+') return _memories[0] + _memories[1];
    if (_operation == '-') return _memories[0] - _memories[1];
    if (_operation == 'x') return _memories[0] * _memories[1];
    if (_operation == '/') return _memories[0] / _memories[1];
    if (_operation == '%') return _memories[0] % _memories[1];
    return 0.0;
  }

  static const kOperations = ['+', '-', 'x', '/', '%', '='];

  void applyCommand(String command) {
    if (command == 'AC') {
      clear();
    } else if (command == 'DEL') {
      deleteDigit();
    } else if (kOperations.contains(command)) {
      setOperation(command);
      if (command != '=') {
        operDisp += command;
      }
    } else {
      addDigit(command);
    }
  }
}
