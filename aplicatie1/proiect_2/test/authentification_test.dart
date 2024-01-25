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


class AuthService {
  Future<bool> login(String username, String password) async {
    // The URL of the /login endpoint
    var url = Uri.parse('http://localhost:8080/api/users/login');

    // The body of the POST request
    var body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      // var success = await MongoDatabase().checkUser(username, password, 'users');

    var response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});
      
      if (response.statusCode == 200) {

        // Parse the response body
        var responseBody = jsonDecode(response.body);

        // Extract the access token
        var accessToken = responseBody['accessToken'];
        var userid = responseBody['userId'];

        // Store the access token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);

        loggedInUsername = username;
        await saveUsername(username);
        await saveAuthenticationState(true);
        
        // print("Token:   ");
        // print(accessToken);
        // print("");
        // print("Userid:   ");
        // print(userid);

        return response.statusCode == 200;
      }
      else
    return response.statusCode == 200;
    } catch (e) {
      print(e);
      print("Error in login");
      return false;
    }
  }

  Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<String?> loadUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<void> saveAuthenticationState(bool isAuthenticated) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isAuthenticated', isAuthenticated);
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAuthenticated') ?? false;
  }

  Future<void> logout() async {
    await saveAuthenticationState(false);
  }

  

}


void main() {
  SharedPreferences.setMockInitialValues({}); // Initialize the SharedPreferences instance for testing
  group('AuthService Tests', () {
  test('Login successful', () async {
    // Arrange
    final AuthService authService = AuthService();
    final username = 'not';
    final password = 'not';

    // Act
    final bool result = await authService.login(username, password);

    print(result);

    // Assert
    expect(result, true);

    // Cleanup
    await authService.logout(); // Ensure that after testing, the user is logged out
  });

  test('Login not successful', () async {
    // Arrange
    final AuthService authService = AuthService();
    final username = 'not1';
    final password = 'not1';

    // Act
    final bool result = await authService.login(username, password);

    print(result);

    // Assert
    expect(result, false);

    // Cleanup
    await authService.logout(); // Ensure that after testing, the user is logged out
  });
  });
}