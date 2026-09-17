import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Simple Calculator',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3257D5)), useMaterial3: true),
    home: const CalculatorPage(),
  );
}

class MyApp extends CalculatorApp { const MyApp({super.key}); }

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});
  @override State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0', _expression = '';
  double? _firstValue;
  String? _operator;
  bool _replaceDisplay = false;

  void _digit(String digit) => setState(() {
    if (_display == 'Error' || _replaceDisplay) { _display = digit; _replaceDisplay = false; }
    else { _display = _display == '0' ? digit : '$_display$digit'; }
  });
  void _decimal() => setState(() {
    if (_display == 'Error' || _replaceDisplay) { _display = '0.'; _replaceDisplay = false; }
    else if (!_display.contains('.')) _display = '$_display.';
  });
  void _operation(String next) {
    if (_display == 'Error') return;
    setState(() {
      final current = double.parse(_display);
      if (_firstValue != null && _operator != null && !_replaceDisplay) {
        final result = _calculate(_firstValue!, current, _operator!);
        if (result == null) { _error(); return; }
        _firstValue = result; _display = _format(result);
      } else { _firstValue = current; }
      _operator = next; _expression = '${_format(_firstValue!)} $next'; _replaceDisplay = true;
    });
  }
  void _equals() {
    if (_firstValue == null || _operator == null || _display == 'Error') return;
    setState(() {
      final second = double.parse(_display); final result = _calculate(_firstValue!, second, _operator!);
      if (result == null) { _error(); return; }
      _expression = '${_format(_firstValue!)} $_operator ${_format(second)} =';
      _display = _format(result); _firstValue = null; _operator = null; _replaceDisplay = true;
    });
  }
  double? _calculate(double left, double right, String op) => switch (op) { '+' => left + right, '−' => left - right, '×' => left * right, '÷' => right == 0 ? null : left / right, _ => null };
  String _format(double value) => value == value.roundToDouble() ? value.toInt().toString() : value.toStringAsPrecision(12).replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  void _error() { _display = 'Error'; _expression = 'Cannot divide by zero'; _firstValue = null; _operator = null; _replaceDisplay = true; }
  void _clear() => setState(() { _display = '0'; _expression = ''; _firstValue = null; _operator = null; _replaceDisplay = false; });
  void _backspace() { if (_replaceDisplay || _display == 'Error') { _clear(); return; } setState(() => _display = _display.length > 1 ? _display.substring(0, _display.length - 1) : '0'); }

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF16213E);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FC),
      body: SafeArea(child: Center(child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380, maxHeight: 500),
        child: Padding(padding: const EdgeInsets.all(14), child: Column(children: [
          const Padding(padding: EdgeInsets.fromLTRB(4, 4, 4, 12), child: Row(children: [Icon(Icons.calculate_rounded, color: Color(0xFF3257D5)), SizedBox(width: 8), Text('Simple Calculator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: navy))])),
          Expanded(child: Container(width: double.infinity, padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(24)), child: Column(children: [
            Expanded(child: Align(
              alignment: Alignment.bottomRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.bottomRight,
                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Text(_expression, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFFB6C4EA), fontSize: 18)), const SizedBox(height: 8),
                  Text(_display, style: const TextStyle(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w300)),
                ]),
              ),
            )), const SizedBox(height: 8),
            _row([_Key('C', _clear, accent: true), _Key('⌫', _backspace, accent: true), _Key('÷', () => _operation('÷'), operator: true)]),
            _row([_Key('7', () => _digit('7')), _Key('8', () => _digit('8')), _Key('9', () => _digit('9')), _Key('×', () => _operation('×'), operator: true)]),
            _row([_Key('4', () => _digit('4')), _Key('5', () => _digit('5')), _Key('6', () => _digit('6')), _Key('−', () => _operation('−'), operator: true)]),
            _row([_Key('1', () => _digit('1')), _Key('2', () => _digit('2')), _Key('3', () => _digit('3')), _Key('+', () => _operation('+'), operator: true)]),
            _row([_Key('0', () => _digit('0'), flex: 2), _Key('.', _decimal), _Key('=', _equals, equals: true)]),
          ]))),
          const Padding(padding: EdgeInsets.only(top: 10), child: Text('Basic addition, subtraction, multiplication, and division', style: TextStyle(fontSize: 12, color: Color(0xFF667085)))),
        ])),
      ))),
    );
  }
  Widget _row(List<_Key> keys) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(children: [for (final key in keys) Expanded(flex: key.flex, child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3), child: _CalculatorButton(data: key)))]));
}

class _Key { const _Key(this.label, this.onTap, {this.flex = 1, this.operator = false, this.accent = false, this.equals = false}); final String label; final VoidCallback onTap; final int flex; final bool operator, accent, equals; }
class _CalculatorButton extends StatelessWidget {
  const _CalculatorButton({required this.data}); final _Key data;
  @override Widget build(BuildContext context) {
    final fill = data.equals ? const Color(0xFF5D7CFA) : data.operator ? const Color(0xFF29395F) : data.accent ? const Color(0xFFE0E7FF) : const Color(0xFFF7F8FC);
    final text = data.equals || data.operator ? Colors.white : data.accent ? const Color(0xFF263B9C) : const Color(0xFF16213E);
    return Semantics(button: true, label: data.label, child: SizedBox(height: 40, child: FilledButton(onPressed: data.onTap, style: FilledButton.styleFrom(backgroundColor: fill, foregroundColor: text, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: Text(data.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)))));
  }
}
