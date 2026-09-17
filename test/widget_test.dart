import 'package:flutter_test/flutter_test.dart';
import 'package:simple_calculator/main.dart';

void main() {
  testWidgets('performs a basic addition', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('2'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('3'));
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('5'), findsOneWidget);
  });

  testWidgets('performs a basic subtraction', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('8'));
    await tester.tap(find.text('-'));
    await tester.tap(find.text('1'));
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('7'), findsOneWidget);
  });

  testWidgets('performs a basic multiplication', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('2'));
    await tester.tap(find.text('x'));
    await tester.tap(find.text('9'));
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('18'), findsOneWidget);
  });

  testWidgets('performs a basic division', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('10'));
    await tester.tap(find.text('÷'));
    await tester.tap(find.text('5'));
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('2'), findsOneWidget);
  });

  testWidgets('handles division by zero', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('8'));
    await tester.tap(find.text('÷'));
    await tester.tap(find.text('0'));
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('Error'), findsOneWidget);
  });
}
