import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      primaryColor: Colors.green,
      hintColor: Colors.white,
      fontFamily: 'Roboto',
      // Add more theme properties as needed
    );

    return MaterialApp(
      theme: theme,
      home: TakePhotoPage(),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Photo Page'),
      ),
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
          alignment: Alignment.topLeft, // Aliniere în stânga sus pentru primul buton
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
                backgroundColor: Colors.white, // Culoarea pentru primul buton
              ),
              child: const Icon(Icons.account_box_rounded, color: Colors.grey), // Iconița pentru primul buton
            ),
          ),
        ),
      Align(
          alignment: Alignment.bottomCenter, // Aliniere în mijloc jos pentru al doilea buton
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _takePhoto,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  shape: const CircleBorder(),
                  backgroundColor: Colors.green, // Culoarea pentru al doilea buton
                ),
                child: const Icon(Icons.camera, color: Colors.white), // Iconița pentru al doilea buton
              ),
      Align(
          alignment: Alignment.bottomRight, // Aliniere în dreapta jos pentru butonul de galerie
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: (){ Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()),
                );
                },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
                backgroundColor: Colors.blue, // Culoarea pentru butonul de galerie
              ),
              child: const Icon(Icons.dashboard_outlined, color: Colors.white), // Iconița pentru butonul de galerie
            ),
          ),
        ),
      ],
    )
    ),
    Align(
      alignment: Alignment.bottomCenter, // Aliniere în mijloc jos pentru al doilea buton
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0), // Adăugare padding doar în partea de jos
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
                backgroundColor: Colors.green, // Culoarea pentru al doilea buton
              ),
              child: const Icon(Icons.photo, color: Colors.white), // Iconița pentru al doilea buton
            ),
          ],
        ),
      ),
    ),
    SizedBox(height: 16), // Adăugare bottom padding
     Align(
          alignment: Alignment.bottomLeft, // Aliniere în dreapta jos pentru butonul de galerie
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: (){ Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                );
                },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: const CircleBorder(),
                backgroundColor: Colors.blue, // Culoarea pentru butonul de galerie
              ),
              child: const Icon(Icons.history, color: Colors.white), // Iconița pentru butonul de galerie
            ),
          ),
        ),
    ],
    )
    )
    );
}
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                MaterialPageRoute(builder: (context) => const AccountPage()),
              );
            }),
            const SizedBox(height: 16),
            MenuItemButton('Login', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }),
            const SizedBox(height: 16),
            MenuItemButton('Signup', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  final List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Page'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
          );
        },
      ),
    );
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Page'),
      ),
      body: Align(
        alignment: const Alignment(0.9, 0.9),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            shape: const CircleBorder(),
            backgroundColor: Colors.blue,
          ),
          child: const Icon(Icons.home, color: Color.fromARGB(255, 255, 255, 255),),
        ),
      ),
    );
  }
}


// Login page


class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
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
                onPressed: () {
                  // Adaugă logica de autentificare aici
                  String username = usernameController.text;
                  String password = passwordController.text;
                  print('Username: $username, Password: $password');
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
      appBar: AppBar(
        title: const Text('SIGN UP'),
      ),
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
                onPressed: () {
                  // Logica de validare a parolei
                  String username = usernameController.text;
                  String password = passwordController.text;
                  String confirmPassword = confirmPasswordController.text;
                  String email = emailController.text;

                  if (password == confirmPassword) {
                    // Parolele coincid
                    print('Username: $username, Password: $password, Email: $email');
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
              )
            ],
          ),
        ),
      ),
    );
  }
}








