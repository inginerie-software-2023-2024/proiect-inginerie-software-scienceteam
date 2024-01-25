import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:aplicatie/main.dart'; // Replace with the actual path to your main.dart file
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:io';

void main() {
  testWidgets('Password recovery page should render', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PasswordRecoveryPage()));

    expect(find.byType(PasswordRecoveryPage), findsOneWidget);
  });

  testWidgets('Email field should be present', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PasswordRecoveryPage()));

    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Submit button should be present', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: PasswordRecoveryPage()));

    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });
}