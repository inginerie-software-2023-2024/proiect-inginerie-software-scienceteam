import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bug Finder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuItemButton('Take Photo', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TakePhotoPage()),
              );
            }),
            const SizedBox(height: 16),
            MenuItemButton('Dashboard', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
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

class MenuItemButton extends StatelessWidget {
  final String text;
  final Function onTap;

  const MenuItemButton(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap as void Function()?,
      child: Text(text),
    );
  }
}

class TakePhotoPage extends StatefulWidget {
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
      body: Align(
        alignment: const Alignment(0.9, 0.9), // Aliniere în partea dreaptă jos pentru primul buton
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end, // Ajustează alinierea pentru a fi în partea dreaptă
          children: [
            ElevatedButton(
              onPressed: () {
                // Acțiune pentru primul buton (în cazul de față, navigare înapoi)
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                shape: CircleBorder(),
                backgroundColor: Colors.blue,
              ),
              child: const Icon(Icons.home, color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Align(
        //alignment: const Alignment(0, 0.9), // Aliniere în mijloc jos pentru al doilea buton
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                shape: CircleBorder(),
                backgroundColor: Colors.green, // Culoarea pentru al doilea buton
              ),
              child: const Icon(Icons.photo, color: Color.fromARGB(255, 255, 255, 255)), // Iconița pentru al doilea buton
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _takePhoto,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                shape: CircleBorder(),
                backgroundColor: Colors.orange, // Culoarea pentru butonul de a lua fotografii
              ),
              child: const Icon(Icons.camera, color: Color.fromARGB(255, 255, 255, 255)), // Iconița pentru butonul de a lua fotografii
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Page'),
      ),
      body: Align(
        alignment: const Alignment(0.9, 0.9),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
            backgroundColor: Colors.blue,
          ),
          child: const Icon(Icons.home, color: Color.fromARGB(255, 255, 255, 255),),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Page'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Page'),
      ),
      body: Align(
        alignment: const Alignment(0.9, 0.9),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(16),
            shape: CircleBorder(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Adaugă logica de autentificare aici
                String username = usernameController.text;
                String password = passwordController.text;
                print('Username: $username, Password: $password');
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signup Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Adaugă logica de înregistrare aici
                String username = usernameController.text;
                String password = passwordController.text;
                String email = emailController.text;
                print('Username: $username, Password: $password, Email: $email');
              },
              child: Text('Signup'),
            ),
          ],
        ),
      ),
    );
  }
}







