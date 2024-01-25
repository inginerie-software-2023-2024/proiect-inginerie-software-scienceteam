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
var result = false;

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
        // var userid = responseBody['userId'];

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

void updateUser(Map<String, dynamic> userDataToUpdate, String accessToken) async {
    final url = Uri.parse('http://localhost:8080/api/users/logged/update');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(userDataToUpdate),
    );

    if (response.statusCode == 200) {
      print('User updated successfully');
      loggedInUsername = userDataToUpdate['username'];
      
      print(loggedInUsername);
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      // Now you can use jsonResponse in your application
       
      result = true;

    } else {
      print('Failed to update user. Status code: ${response.statusCode}');

    }
  }


void main() {
  SharedPreferences.setMockInitialValues({}); // Initialize the SharedPreferences instance for testing
  group('Update Tests', () {
  test('Update successful', () async {
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

    if (response.statusCode == 200) {
                      var responseBody = jsonDecode(response.body);
                      if (responseBody['success']) {
                        result = true;
                      } else {
                        result = false;
                      }
    }

    final AuthService authService = AuthService();

    // Act
    final bool result1 = await authService.login(username, password);

    Map<String, dynamic> userDataToUpdate = {
                    'username': 'not24',
                    'password': 'not24',
                    'repeat_password': 'not24',
                    'email': 'not24@gmail.com',
                  };

    updateUser(userDataToUpdate, accessToken);

    
    await Future.delayed(Duration(seconds: 5));

    print(result);
    // Assert
    expect(result, true);
  });


  test('Update not successful', () async {

    result = false;

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

    if (response.statusCode == 200) {
                      var responseBody = jsonDecode(response.body);
                      if (responseBody['success']) {
                        result = true;
                      } else {
                        result = false;
                      }
    }

    final AuthService authService = AuthService();

    // Act
    final bool result1 = await authService.login(username, password);

    Map<String, dynamic> userDataToUpdate = {
                    'username': 'not24',
                    'password': 'not24',
                    'repeat_password': 'not24',
                    'email': 'not24@gmail.com',
                  };

    updateUser(userDataToUpdate, accessToken);

    
    await Future.delayed(Duration(seconds: 5));

    print(result);
    // Assert
    expect(result, false);
  });
}
  );
}