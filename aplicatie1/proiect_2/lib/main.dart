//import 'dart:html';
import 'dart:io';

// import 'package:aplicatie/mongo_db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await MongoDatabase.connect();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  loggedInUsername = prefs.getString('username');
  runApp(MyApp());
}

String? loggedInUsername;

class AuthService {
  Future<bool> login(String username, String password) async {
    // The URL of the /login endpoint
    var url = Uri.parse('http://10.0.2.2:8080/api/users/login');

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
        
        print("Token:   ");
        print(accessToken);
        print("");
        print("Userid:   ");
        print(userid);

        return response.statusCode == 200;
      }
      else
    return response.statusCode == 200;
    } catch (e) {
      print(e);
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

      await _uploadPhoto(_selectedImage!);
    }
  }

  void addHistory(Map<String, dynamic> historyData, String accessToken) async {
  final url = Uri.parse('http://10.0.2.2:8080/api/history/addHistory');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(historyData),
  );

  if (response.statusCode == 200) {
    print('History added successfully');
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    // Now you can use jsonResponse in your application
  } else {
    print('Failed to add history. Status code: ${response.statusCode}');
  }
}

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });

      await _uploadPhoto(_selectedImage!);
    }
  }

  Future<void> _uploadPhoto(File image) async {
  final url = Uri.parse('http://10.0.2.2:8080/api/users/logged/uploadPhoto');

  // Load the access token from shared preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var accessToken = prefs.getString('accessToken');

  // Create a multipart request
  var request = http.MultipartRequest('POST', url);

  // Add the access token to the Authorization header
  request.headers['Authorization'] = 'Bearer $accessToken';
  print("Hello1");
  // Add the image to the request
  print('Before adding file');
  request.files.add(await http.MultipartFile.fromPath('photo', image.path));
  print('After adding file');
  print("_selectedImage: $_selectedImage.path");
  // Send the request
  var response = await request.send();
  print("Hello2");
  if (response.statusCode == 200) {
    print('Photo uploaded successfully');
    var finalResponse = await http.Response.fromStream(response);
    var decodedData = jsonDecode(finalResponse.body);
    Map<String, dynamic> data = decodedData['data'];
    print(data["_id"]);
    String bugId = data["_id"];


    // final url1 = Uri.parse('http://10.0.2.2:8080/api/history/addHistory');
    
    // Map<String, String> headers = {
    // 'Content-Type': 'application/json; charset=UTF-8',
    // 'Authorization': 'Bearer $accessToken',};

    addHistory({'insect':bugId}, accessToken!);

    // now we redirect to bugPage
    Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BugPage(data)),
          );
    
  } else {
    print('Failed to upload photo. Status code: ${response.statusCode}');
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
                    )
                    ;
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
  List<Map<String, dynamic>> items1 = [];
  List<String> items = ["1"
  ];

  Future<void> fetchHistory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/history/getHistory'), // replace with your server URL
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        List<dynamic> historyData = decodedData['data'];
        
        // Extract insect name from each history item
        for (var item in historyData) {
          Map<String, dynamic> insectData = item['insect'];
          items1.add(insectData);
          print(insectData);
          String insectName = insectData["name"];
          print(insectName);
          // Do something with insectName
        }

        setState(() {
          items = historyData.map((item) => item['insect']['name'].toString()).toList();
          print("Test items list");
          
          print(items1);
        });
      } else {
        // handle error
      }
    }
  }

  

  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    fetchHistory().then((_) => resetFilter());
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
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                var item = items1.firstWhere((i) => i['name'] == filteredItems[index]);
                                // print(items1[index]["name"]);
                                // print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                                // print(filteredItems[index]);
                                return BugPage(item);
                              }),
                            );
                          }
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
var loggedInUsername1 = "Ion";
              
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
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()), 
                          (Route<dynamic> route) => false,
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
                child: const Text("Sign Up"),
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
                    
                    var url = Uri.parse('http://10.0.2.2:8080/api/users/save');

                    var body = jsonEncode({
                      'username': username,
                      'email': email,
                      'password': password,
                      'repeat_password': confirmPassword,
                    });
                    print("salut");
                    var response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});
                    // print("salut1");
                    // print(response.statusCode);
                    
                    if (response.statusCode == 200) {
                      var responseBody = jsonDecode(response.body);
                      if (responseBody['success']) {
                        print('Signup successful');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                        
                      } else {
                      }

                  } else
                  {
                      var responseBody = jsonDecode(response.body);
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

  void requestPasswordReset(String email) async {
  final url = Uri.parse('http://10.0.2.2:8080/api/users/requestResetPassword');

  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: jsonEncode({"email":email}),
  );
  

  if (response.statusCode == 200) {
    print('Password reset link sent successfully');
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    // Now you can use jsonResponse in your application
  } else {
    print('Failed to send password reset link. Status code: ${response.statusCode}');
  }
}

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
                    
                    requestPasswordReset(email);

                    //redirect to login
                  
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Check your email'),
          content: const Text('We have sent a password reset link to your email address.'),
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
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController newPasswordController_r = TextEditingController();
  final TextEditingController newUsernameController = TextEditingController();
  final TextEditingController newEmailController = TextEditingController();
  

  void updateUser(Map<String, dynamic> userDataToUpdate, String accessToken) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/users/logged/update');

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
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      // Now you can use jsonResponse in your application
    } else {
      print('Failed to update user. Status code: ${response.statusCode}');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password Page'),
      ),
      backgroundColor: Colors.green,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              TextFormField(
                obscureText: false,
                controller: newUsernameController,
                decoration: InputDecoration(
                  labelText: 'New Username',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 32),
              TextFormField(
                obscureText: false,
                controller: newEmailController,
                decoration: InputDecoration(
                  labelText: 'New Email',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 32),
              TextFormField(
                obscureText: true,
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 32),
              TextFormField(
                obscureText: true,
                controller: newPasswordController_r,
                decoration: InputDecoration(
                  labelText: 'Repeat New Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
              ),
              const SizedBox(height: 64),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: () async {

                  Map<String, dynamic> userDataToUpdate = {
                    'username': newUsernameController.text,
                    'password': newPasswordController.text,
                    'repeat_password': newPasswordController_r.text,
                    'email': newEmailController.text,
                  };

                  //accessToken
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String? accessToken = prefs.getString('accessToken');

                  updateUser(userDataToUpdate, accessToken!);

                  // TODO: Implement password change logic

                  // Clear the text fields
                  newPasswordController.clear();
                  newPasswordController_r.clear();
                  newUsernameController.clear();
                  newEmailController.clear();
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

// Trebuie delete nu post
class DeleteAccountPage extends StatelessWidget {
  final TextEditingController currentPasswordController = TextEditingController();
  final AuthService authService = AuthService();
  Future<void> deleteUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('accessToken');

  if (accessToken != null) {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:8080/api/users/logged/delete'), // replace with your server URL
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      print('User deleted successfully');
      // Handle successful deletion
    } else {
      print('Failed to delete user');
      // Handle error
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delete Account Page'),
      ),
      backgroundColor: Colors.green,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                onPressed: () async {
                  // String currentPassword = currentPasswordController.text;
                  
                  
                  deleteUser();

                  // Logout
                  await authService.logout();

                        // Navigare la LoginPage și eliminarea tuturor paginilor anterioare din stiva de navigare
                  Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()), 
                  (Route<dynamic> route) => false,
                  );

                  // Clear the text fields
                  // currentPasswordController.clear();
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


// Page named bugPage that will be used to display the bug details
class BugPage extends StatelessWidget {
  final Map<String, dynamic> data;
  const BugPage(this.data, {Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var name = data["name"];
    var description = data["description"];
    var plants = data["plants"];
    var insecticide = data["insecticide"];
    var prevention = data["prevention_methods"];
    return Scaffold(
      appBar: AppBar(title: const Text('Bug Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('Bug Name: $name'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('Bug Description: $description'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('Plants affected: $plants'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('Insecticide: $insecticide'),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text('Prevention: $prevention'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// Page for resetting the password
class ResetPasswordPage extends StatelessWidget {
  final String authenticationToken;
  final String userId;

  const ResetPasswordPage({
    required this.authenticationToken,
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Reset Password Page'),
            const SizedBox(height: 20),
            Text('Authentication Token: $authenticationToken'),
            Text('User ID: $userId'),
            const SizedBox(height: 20),
            // Textfield new password
            
            ElevatedButton(
              onPressed: () {
                // TODO: Implement password reset logic
              },
              child: const Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}

