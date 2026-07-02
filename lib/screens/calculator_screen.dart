import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _display = '0';
  String _previousValue = '';
  String _operator = '';
  bool _isNewInput = true;

  void _clear() {
    setState(() {
      _display = '0';
      _previousValue = '';
      _operator = '';
      _isNewInput = true;
    });
  }

  void _backspace() {
    if (_display.length > 1) {
      setState(() {
        _display = _display.substring(0, _display.length - 1);
        if (_display.isEmpty) {
          _display = '0';
        }
      });
    }
  }

  void _inputNumber(String number) {
    setState(() {
      if (_isNewInput) {
        _display = number;
        _isNewInput = false;
      } else {
        if (_display == '0') {
          _display = number;
        } else {
          _display += number;
        }
      }
    });
  }

  void _inputDecimal() {
    if (_isNewInput) {
      setState(() {
        _display = '0.';
        _isNewInput = false;
      });
    } else if (!_display.contains('.')) {
      setState(() {
        _display += '.';
      });
    }
  }

  void _calculateOperator(String op) {
    if (_operator.isNotEmpty && !_isNewInput) {
      _calculateResult();
    }
    
    setState(() {
      _previousValue = _display;
      _operator = op;
      _isNewInput = true;
    });
  }

  void _calculateResult() {
    if (_operator.isEmpty || _previousValue.isEmpty) return;
    
    double result;
    double currentValue = double.parse(_display);
    double previousValue = double.parse(_previousValue);
    
    switch (_operator) {
      case '+':
        result = previousValue + currentValue;
        break;
      case '-':
        result = previousValue - currentValue;
        break;
      case '×':
        result = previousValue * currentValue;
        break;
      case '÷':
        if (currentValue == 0) {
          setState(() {
            _display = 'Error';
          });
          return;
        }
        result = previousValue / currentValue;
        break;
      default:
        return;
    }
    
    // Format result to avoid excessive decimal places
    String resultString = result.toStringAsFixed(10);
    resultString = resultString.contains('.') 
        ? resultString.replaceAllTrailingZeros() 
        : resultString;
    
    setState(() {
      _display = resultString;
      _previousValue = '';
      _operator = '';
      _isNewInput = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
      ),
      body: Column(
        children: [
          // Display
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.centerRight,
            child: Text(
              _display,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Buttons
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 16,
              itemBuilder: (context, index) {
                String buttonText;
                Color buttonColor;
                Color textColor;
                VoidCallback onPressed;
                
                switch (index) {
                  case 0:
                    buttonText = 'C';
                    buttonColor = Colors.red;
                    textColor = Colors.white;
                    onPressed = _clear;
                    break;
                  case 1:
                    buttonText = '←';
                    buttonColor = Colors.orange;
                    textColor = Colors.white;
                    onPressed = _backspace;
                    break;
                  case 2:
                    buttonText = '÷';
                    buttonColor = Colors.orange;
                    textColor = Colors.white;
                    onPressed = () => _calculateOperator('÷');
                    break;
                  case 3:
                    buttonText = '×';
                    buttonColor = Colors.orange;
                    textColor = Colors.white;
                    onPressed = () => _calculateOperator('×');
                    break;
                  case 4:
                    buttonText = '7';
                    buttonColor = Colors.grey[200]!;
                    textColor = Colors.black;
                    onPressed = () => _inputNumber('7');
                    break;
                  case 5:
                    buttonText = '8';
                    buttonColor = Colors.grey[200]!;
                    textColor = Colors.black;
                    onPressed = () => _inputNumber('8');
                    break;
                  case 6:
                    buttonText = '9';
                    buttonColor = Colors.grey[200]!;
                    textColor = Colors.black;
                    onPressed = () => _inputNumber('9');
                    break;
                  case 7:
                    buttonText = '-';
                    buttonColor = Colors.orange;
                    textColor = Colors.white;
                    onPressed = () => _calculateOperator('-');
                    break;
                  case 8:
                    buttonText = '4';
                    buttonColor = Colors.grey[200]!;
                    textColor = Colors.black;
                    onPressed = () => _inputNumber('4');
                    break;
                  case 9:
                    buttonText = '5';
                    buttonColor = Colors.grey[200]!;
                    textColor = Colors.black;
                    onPressed = () => _inputNumber('5');
                    break;
                  case 10:
                    buttonText = '6';
                    buttonColor = Colors.grey[200]!;
                    textColor = Colors.black;
                    onPressed = () => _inputNumber('6');
                    break;
                  case 11:
                    buttonText = '+';
                    buttonColor = Colors.orange;
                    textColor = Colors.white;
                    onPressed = () => _calculateOperator('+');
                    break;
                  case 12:
                    buttonText = '1';
                    buttonColor = Colors.grey[200]!;
                    textColor = Colors.black;
                    onPressed = () => _inputNumber('1');
                    break;
                  case 13:
                    buttonText = '2';
                    buttonColor = Colors.grey[200]!;
                    textColor = Colors.black;
                    onPressed = () => _inputNumber('2');
                    break;
                  case 14:
                    buttonText = '3';
                    buttonColor = Colors.grey[200]!;
                    textColor = Colors.black;
                    onPressed = () => _inputNumber('3');
                    break;
                  case 15:
                    buttonText = '=';
                    buttonColor = Colors.blueAccent;
                    textColor = Colors.white;
                    onPressed = _calculateResult;
                    break;
                  default:
                    buttonText = '0';
                    buttonColor = Colors.grey[200]!;
                    textColor = Colors.black;
                    onPressed = () => _inputNumber('0');
                }
                
                return ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    foregroundColor: textColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Extension to remove trailing zeros from a string
extension StringExt on String {
  String removeAllTrailingZeros() {
    if (!contains('.')) return this;
    
    String result = this;
    while (result.endsWith('0')) {
      result = result.substring(0, result.length - 1);
    }
    
    if (result.endsWith('.')) {
      result = result.substring(0, result.length - 1);
    }
    
    return result;
  }
}