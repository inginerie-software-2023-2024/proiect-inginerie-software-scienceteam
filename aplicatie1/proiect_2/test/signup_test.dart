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

// Add the missing import statements


void main() {
  SharedPreferences.setMockInitialValues({}); // Initialize the SharedPreferences instance for testing
  group('Register Tests', () {
  test('Register successful', () async {
    // Arrange
    final username = 'not23';
    final password = 'not23';
    final email = 'not23@gmail.com';
    final confirmPassword = 'not23';

    var url = Uri.parse('http://localhost:8080/api/users/save');

    var body = jsonEncode({
      'username': username,
      'email': email,
      'password': password,
      'repeat_password': confirmPassword,
    });

    
    var response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});

    var result = false;

    if (response.statusCode == 200) {
                      var responseBody = jsonDecode(response.body);
                      if (responseBody['success']) {
                        result = true;
                      } else {
                        result = false;
                      }
    }


    print(result);
    // Assert
    expect(result, true);
  });


  test('Register not successful', () async {
    // Arrange
    final AuthService authService = AuthService();
    final username = 'not23';
    final password = 'not23';
    final email = 'not23@gmail.com';
    final confirmPassword = 'not23';

    var url = Uri.parse('http://localhost:8080/api/users/save');

    var body = jsonEncode({
      'username': username,
      'email': email,
      'password': password,
      'repeat_password': confirmPassword,
    });

    
    var response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});

    var result = false;

    if (response.statusCode == 200) {
                      var responseBody = jsonDecode(response.body);
                      if (responseBody['success']) {
                        result = true;
                      } else {
                        result = false;
                      }
    }


    print(result);

    // Assert
    expect(result, false);

  });
}
  );
}