import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:aplicatie/main.dart'; // Replace with the actual path to your main.dart file
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  testWidgets('App should run', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that our app is running.
    expect(find.byType(MyApp), findsOneWidget);
  });
}