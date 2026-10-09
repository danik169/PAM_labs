import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/main.dart';

void main() {
  testWidgets('Home screen shows greeting', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Hi, Kristin'), findsOneWidget);
  });
}
