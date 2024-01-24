import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:aplicatie/main.dart'; // Replace with the actual path to your main.dart file
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Test navigation to second screen", (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    // Tap the 'Go to second screen' button.
    await tester.tap(find.text('Go to second screen'));
    await tester.pumpAndSettle();

    // Verify that we're on the second screen.
    expect(find.text('Second Screen'), findsOneWidget);
  });
}