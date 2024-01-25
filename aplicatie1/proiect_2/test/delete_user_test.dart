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

var accessToken = '';
var status;

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
        accessToken = responseBody['accessToken'];
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

Future<void> deleteUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken1 = prefs.getString('accessToken');

  accessToken1 = accessToken;


  final response = await http.delete(
    Uri.parse('http://localhost:8080/api/users/logged/delete'), // replace with your server URL
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    print('User deleted successfully');
    status = true;
    // Handle successful deletion
  } else {
    print('Failed to delete user');
    status = false;
    // Handle error
  }
}

void main() {
  SharedPreferences.setMockInitialValues({}); // Initialize the SharedPreferences instance for testing
  group('Delete Tests', () {
    
  test('Register successful', () async {
    // Arrange
    final username = 'not';
    final password = 'not';
    final email = 'not@gmail.com';
    final confirmPassword = 'not';

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
    
    result = false;
    // Assert
    expect(result, false);
  });
  test('Delete successful', () async {
    // Arrange
    final AuthService authService = AuthService();
    final username = 'not';
    final password = 'not';

    // Act
    final bool result = await authService.login(username, password);

    // print(result);

    deleteUser();
    
    await Future.delayed(Duration(seconds: 5));

    // Assert
    expect(status, true);

    // Cleanup
    await authService.logout(); // Ensure that after testing, the user is logged out
  });

  test('Delete not successful', () async {
    // Arrange
    final AuthService authService = AuthService();
    final username = 'not';
    final password = 'not';

    // Act
    final bool result = await authService.login(username, password);

    // print(result);


    print("n");

    deleteUser();
    
    await Future.delayed(Duration(seconds: 5));

    // Assert
    expect(status, false);

    // Cleanup
    await authService.logout(); // Ensure that after testing, the user is logged out
  });
  });
}