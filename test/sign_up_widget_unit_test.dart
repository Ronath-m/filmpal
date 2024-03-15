import 'package:filmpal/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('RegisterPage does not throw exception',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: RegisterPage(
        onTap: () {}, // Mock onTap function
      ),
    ));

    // Verify that the RegisterPage renders without throwing an exception
    expect(find.byType(RegisterPage), findsOneWidget);
  });
}
