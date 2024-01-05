// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}


var selectedIndex = 0;

void _setIndex(int index) {
  selectedIndex = index;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicatie',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Bug Finder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  void _setHome() {
    setState(() {
      selectedIndex = 0;
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }
  
  

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MenuPage();
        break;
      case 1:
        page = AccountPage();
        break;
      case 2:
        page = HistoryPage();
        break;
      case 3:
        page = DashboardPage();
        break;
      case 4:
        page = PhotoPage();
        break;
      case 5:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[                                             //Liber
          

          Expanded(                                                       //Asta este partea care randeaza pagina, doar asta ar trebui sa apara
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,  // ← Here.
            ),
          ),

          ],
          
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _setHome,                 // Aici vreau sa fac un buton care duce la meniu mereu
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


// Butoane Urmatoarele 4 widgeturi sunt pentru meniu

class ButonAccount extends StatelessWidget {
  const ButonAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();
    return ElevatedButton(          //Aici trebuie sa rezolv cu functia
      // onPressed: () => appState.setPageIndex(1),
      onPressed: () {
        print('Account');
      },    
      child: const Text('Account'),
    );
  }
}

class ButonHistory extends StatelessWidget {
  const ButonHistory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('History');
      },
      child: const Text('History'),
    );
  }
}

class ButonDashboard extends StatelessWidget {
  const ButonDashboard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('Dashboard');
      },
      child: const Text('Dashboard'),
    );
  }
}

class ButonPhoto extends StatelessWidget {
  const ButonPhoto({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        print('Take Photo');
      },
      child: const Text('Take Photo'),
    );
  }
}


// Pagini Urmatoarele 5 widgeturi sunt pentru pagini  


class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            // Expanded(
            //   child: Container(
            //     color: Theme.of(context).colorScheme.primaryContainer,
            //   ),
            // ),
            SizedBox(height: 16),
            ButonAccount(),

            SizedBox(height: 16),
            ButonDashboard(),

            SizedBox(height: 16),
            ButonHistory(),

            SizedBox(height: 16),
            ButonPhoto(),
          ],
      ),
    ),
    );
    
  }
}

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
    );
    
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
    );
    
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
    );
    
  }
}

class PhotoPage extends StatelessWidget {
  const PhotoPage({super.key});

  @override
  Widget build(BuildContext context) {
    //var appState = context.watch<MyAppState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo'),
      ),
    );
    
  }
}

class MyAppState extends ChangeNotifier {

  var pageIndex = 0;

  void setPageIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }


}




