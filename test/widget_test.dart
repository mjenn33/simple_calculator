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
    expect(find.text('5'), findsNWidgets(2));
  });

  testWidgets('performs a basic subtraction', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('8'));
    await tester.tap(find.text('−'));
    await tester.tap(find.text('1'));
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('7'), findsNWidgets(2));
  });

  testWidgets('performs a basic multiplication', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('2'));
    await tester.tap(find.text('×'));
    await tester.tap(find.text('9'));
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('18'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('performs a basic division', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('4'));
    await tester.tap(find.text('÷'));
    await tester.tap(find.text('8'));
    await tester.tap(find.text('='));
    await tester.pump();
    expect(find.text('0.5'), findsOneWidget);
  });

  testWidgets('tests the clear button', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    await tester.tap(find.text('8'));
    await tester.tap(find.text('1'));
    await tester.tap(find.text('C'));
    await tester.tap(find.text('9'));
    await tester.tap(find.text('2'));
    await tester.pump();
    expect(find.text('92'), findsOneWidget);
  });
}
