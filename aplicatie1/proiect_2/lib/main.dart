import 'dart:io';

import 'package:aplicatie/mongo_db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(MyApp());
}

String? loggedInUsername;

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
      var success = await MongoDatabase().checkUser(username, password, 'users');
      if (success) {
        loggedInUsername = username;
        await saveAuthenticationState(true);
      }
      return success;
    } catch (e) {
      print(e);
      return false;
    }
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

class MyApp extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.green,
        hintColor: Colors.white,
        fontFamily: 'Roboto',
        // Add more theme properties as needed
      ),
      home: FutureBuilder<bool>(
        future: authService.isAuthenticated(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            bool isAuthenticated = snapshot.data ?? false;
            return isAuthenticated ? FirstPage() : FirstPage();
          }
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  final AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async {
          // La apăsarea pe ecran, navighează către a doua pagină
          Future<bool> isLoggedIn = authService.isAuthenticated();
          if(await isLoggedIn){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TakePhotoPage()),
          );
          }
          else
          {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
          }
          
        },
        child: Container(
          // Acest container ocupă tot spațiul ecranului și are o imagine de fundal
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bug_bg.jpg'), // Schimbați cu calea către imaginea dvs.
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Align(
              alignment: Alignment.topCenter,
                child: Text(
                'BUG SCAN',
                style: TextStyle(color: Colors.green, fontSize: 30.0),
            ),
            ),
          ),
      ),
    ),
    );
  }
}

class MenuItemButton extends StatelessWidget {
  final String text;
  final Function onTap;

  const MenuItemButton(this.text, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap as void Function()?,
      child: Text(text),
    );
  }
}

class TakePhotoPage extends StatefulWidget {
  const TakePhotoPage({super.key});

  @override
  _TakePhotoPageState createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends State<TakePhotoPage> {
  final AuthService authService = AuthService(); // Creează o instanță a serviciului de autentificare
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: authService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          bool isAuthenticated = snapshot.data ?? false;

          if (isAuthenticated) {
            // Dacă utilizatorul este autentificat, afișează conținutul paginii TakePhotoPage
            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bug_bg.jpg'),  
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AccountPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.white,
                          ),
                          child: const Icon(Icons.account_box_rounded, color: Colors.grey),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: _takePhoto,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              shape: const CircleBorder(),
                              backgroundColor: Colors.green,
                            ),
                            child: const Icon(Icons.camera, color: Colors.white),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const DashboardPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(16),
                                  shape: const CircleBorder(),
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Icon(Icons.dashboard_outlined, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: _pickImage,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                shape: const CircleBorder(),
                                backgroundColor: Colors.green,
                              ),
                              child: const Icon(Icons.photo, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HistoryPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: const CircleBorder(),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Icon(Icons.history, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Dacă utilizatorul nu este autentificat, redirecționează-l către pagina de login
            return Scaffold(
              body: Center(
                child: MenuItemButton('Login', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }),
              ),
            );
          }
        }
      },
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService(); // Creează o instanță a serviciului de autentificare
    var bugCounter = 0;
    return FutureBuilder<bool>(
      future: authService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          bool isAuthenticated = snapshot.data ?? false;

          if (isAuthenticated) {
            // Dacă utilizatorul este autentificat, afișează conținutul paginii DashboardPage
            return Scaffold(
              appBar: AppBar(
                title: const Text('Bug Finder'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MenuItemButton('Take Photo', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TakePhotoPage()),
                      );
                    }),
                    const SizedBox(height: 16),
                    MenuItemButton('Dashboard', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DashboardPage()),
                      );
                    }),
                    const SizedBox(height: 16),
                    MenuItemButton('History', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HistoryPage()),
                      );
                    }),
                    const SizedBox(height: 16),
                    MenuItemButton('Account', () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountPage()),
                      );
                    }),
                    Text(
                      'Bugs Found: $bugCounter', // Display the bug counter
                      style: TextStyle(fontSize: 24),
                        ),
                  ],
                ),
              ),
            );
          } else {
            // Dacă utilizatorul nu este autentificat, redirecționează-l către pagina de login
            return MenuItemButton('Login', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            });
          }
        }
      },
    );
  }
}

class HistoryPage extends StatefulWidget {
  HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = items;
  }

  void filterItems(String searchText) {
    setState(() {
      filteredItems = items
          .where((item) => item.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

   void resetFilter() {
    setState(() {
      filteredItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService(); // Creează o instanță a serviciului de autentificare

    return FutureBuilder<bool>(
      future: authService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          bool isAuthenticated = snapshot.data ?? false;

          if (isAuthenticated) {
            // Dacă utilizatorul este autentificat, afișează conținutul paginii HistoryPage
            return Scaffold(
              appBar: AppBar(
                title: const Text('History Page'),
              ),
              backgroundColor: Color.fromARGB(255, 0, 255, 0),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onSubmitted: (value) => filterItems(value),
                      decoration: InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                        filled: true, // Set filled to true
                        fillColor: Colors.white, // Set fillColor to white
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(filteredItems[index]),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                  onPressed: resetFilter,
                  child: Text('Reset Filter'),
          ),
                ],
              ),
            );
          } else {
            // Dacă utilizatorul nu este autentificat, redirecționează-l către pagina de login
            return Scaffold(
              body: Center(
                child: MenuItemButton('Login', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }),
              ),
            );
          }
        }
      },
    );
  }
}

class AccountPage extends StatelessWidget {
  final AuthService authService = AuthService(); // Creează o instanță a serviciului de autentificare

  // Aici adaugam schimbarea parolei

  AccountPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: authService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          bool isAuthenticated = snapshot.data ?? false;

          if (isAuthenticated) {
            // Dacă utilizatorul este autentificat, afișează conținutul paginii AccountPage
            return Scaffold(
              appBar: AppBar(
                title: Text('Account Page -> ' + loggedInUsername!),
              ),
              backgroundColor: Color.fromARGB(255, 0, 255, 0),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                        );
                      },
                      child: Text('Change Password'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => DeleteAccountPage()),
                        );
                      },
                      child: Text('Delete Account'),
                    ),
                    // Alte elemente ale paginii AccountPage pot fi adăugate aici
                    ElevatedButton(
                      onPressed: () async {
                        // Logout
                        await authService.logout();

                        // Navigare la LoginPage și eliminarea tuturor paginilor anterioare din stiva de navigare
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        backgroundColor: Colors.red, // Culoarea butonului de logout
                      ),
                      child: const Text("Logout", style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Dacă utilizatorul nu este autentificat, redirecționează-l către pagina de login
            return Scaffold(
              body: Center(
                child: MenuItemButton('Login', () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                }),
              ),
            );
          }
        }
      },
    );
  }
}



// Login page


class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green, // Set the background color here
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "WELCOME BACK!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Username",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              child:TextField(
                onTap: () {
                  // Handle tap outside the container
                  FocusScope.of(context).unfocus(); // Hide the keyboard
                },
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
              child:TextField(
                onTap: () {
                  // Handle tap outside the container
                  FocusScope.of(context).unfocus(); // Hide the keyboard
                },
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                
                onPressed: () async {
                  // Adaugă logica de autentificare aici
                  String username = usernameController.text;
                  String password = passwordController.text;
                  bool isLoggedIn = await authService.login(username, password);
                  if (isLoggedIn) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => TakePhotoPage()),);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Invalid username or password!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Sign In'),
              ),
              const SizedBox(height: 16),
              const Text("You don't have an account?", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
              
              TextButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                child: const Text("Sign up"),
              ),
                const SizedBox(height: 16),
                Text("Forgot your password?", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RecoveryPasswordPage()),
                  );
                },
                child: const Text("Recover your password"),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}

class SignupPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  SignupPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "WELCOME BACK!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "Username",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  onTap: () {
                  // Handle tap outside the container
                  FocusScope.of(context).unfocus(); // Hide the keyboard
                },
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Email",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  onTap: () {
                  // Handle tap outside the container
                  FocusScope.of(context).unfocus(); // Hide the keyboard
                },
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  onTap: () {
                  // Handle tap outside the container
                  FocusScope.of(context).unfocus(); // Hide the keyboard
                },
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Confirm Password",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  onTap: () {
                  // Handle tap outside the container
                  FocusScope.of(context).unfocus(); // Hide the keyboard
                },
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: () async {
                  // Logica de validare a parolei
                  String username = usernameController.text;
                  String password = passwordController.text;
                  String confirmPassword = confirmPasswordController.text;
                  String email = emailController.text;

                  if (password == confirmPassword && password.isNotEmpty && confirmPassword.isNotEmpty && username.isNotEmpty && email.isNotEmpty) {
                    // Parolele coincid
                    
                    var url = Uri.parse('http://localhost:8080/api/users/save');

                    var body = jsonEncode({
                      'username': username,
                      'email': email,
                      'password': password,
                      'confirmPassword': confirmPassword,
                    });
                    
                    var response = await http.post(url, body: body, headers: {"Content-Type": "application/json"});

                    if (response.statusCode == 200) {
                      var responseBody = jsonDecode(response.body);
                      if (responseBody['success']) {
                        print('Signup successful');
                      } else {
                        print('Signup failed: ${responseBody['message']}');
                      }

                  } else {
                    // Parolele nu coincid
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Passwords do not match!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
                },
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 16),
              const Text("You already have an account?", style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
              TextButton(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: const Text("Sign in"),
              ),
              
              
            ],
          ),
        ),
      ),
    );
  }
}

class RecoveryPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
                title: const Text('Password Recovery Page'),
              ),
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onTap: () {
                  // Handle tap outside the container
                  FocusScope.of(context).unfocus(); // Hide the keyboard
                },
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: () async {
                  String email = emailController.text;

                  if (email.isNotEmpty) {
                    var url = Uri.parse('http://localhost:8080/api/users/recover');

                    var body = jsonEncode({
                      'email': email,
                    });

                    var response = await http.post(url, body: body, headers: {"Content-Type": "application/json"});

                    if (response.statusCode == 200) {
                      var responseBody = jsonDecode(response.body);
                      if (responseBody['success']) {
                        print('Recovery email sent successfully');
                      } else {
                        print('Failed to send recovery email: ${responseBody['message']}');
                      }
                    } else {
                      print('Failed to send recovery email');
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text('Please enter your email address'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Send Recovery Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ChangePasswordPage extends StatelessWidget {
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password Page'),
      ),
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                obscureText: true,
                controller: currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: () {
                  String currentPassword = currentPasswordController.text;
                  String newPassword = newPasswordController.text;

                  // TODO: Implement password change logic

                  // Clear the text fields
                  currentPasswordController.clear();
                  newPasswordController.clear();
                },
                child: const Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class DeleteAccountPage extends StatelessWidget {
  final TextEditingController currentPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password Page'),
      ),
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                obscureText: true,
                controller: currentPasswordController,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: () {
                  String currentPassword = currentPasswordController.text;

                  // TODO: Implement password change logic

                  // Clear the text fields
                  currentPasswordController.clear();
                },
                child: const Text('Delete account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



