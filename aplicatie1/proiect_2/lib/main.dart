import 'package:flutter/material.dart';

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

class TakePhotoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take Photo Page'),
      ),
      body: Align(
        alignment: const Alignment(0.9, 0.9),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
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
            SizedBox(height: 16), // Adaugă un spațiu între butoane (poți ajusta valoarea la nevoie)
            ElevatedButton(
              onPressed: () {
                // Acțiune pentru al doilea buton
                // Poți adăuga logica dorită aici
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(16),
                shape: CircleBorder(),
                backgroundColor: Colors.green, // Culoarea pentru al doilea buton
              ),
              child: const Icon(Icons.add, color: Color.fromARGB(255, 255, 255, 255)), // Iconița pentru al doilea buton
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History Page'),
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
