// Basic Flutter widget test for the Date Picker app.

import 'package:flutter_test/flutter_test.dart';

import 'package:kill_of_hill_date/main.dart';

void main() {
  testWidgets('App loads with intro screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DatePickerApp());

    // Verify that the intro screen title appears
    expect(find.text('Our Perfect Date'), findsOneWidget);

    // Verify that the start button appears
    expect(find.text("Let's Begin"), findsOneWidget);
  });
}
