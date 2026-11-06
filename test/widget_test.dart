import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_app/app.dart';

import 'courses_cubit_test.dart' show FakeCourseRepository;

void main() {
  testWidgets('Home shows Loading first, then the greeting from JSON',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(repository: FakeCourseRepository()));

    // Prima imagine: starea Loading.
    expect(find.byType(CircularProgressIndicator), findsWidgets);

    await tester.pumpAndSettle();

    expect(find.text('Hi, Kristin'), findsOneWidget);
    expect(find.text('Packaging Design'), findsOneWidget);
  });

  testWidgets('My courses opens the list, search can lead to the Empty state',
      (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(repository: FakeCourseRepository()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('My courses'));
    await tester.pumpAndSettle();

    expect(find.text('React Front To back'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzzzzz');
    // Căutarea are debounce (350 ms).
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.text('No courses found'), findsOneWidget);
  });
}
