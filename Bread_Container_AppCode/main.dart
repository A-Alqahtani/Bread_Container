import 'package:breadbox/screens/adminreadscreen.dart';
import 'package:breadbox/screens/homescreen.dart';
import 'package:breadbox/screens/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/loginscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuthenticated = false; // Add a state variable to track authentication

  void setAuthenticated(bool value) {
    setState(() {
      isAuthenticated = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Choose the initial route based on the authentication state
    final initialRoute = isAuthenticated ? '/home' : '/login';

    return MaterialApp(
      title: 'Smart Bread Container',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => Mysplashscreen(),

      },
      debugShowCheckedModeBanner: false,
    );
  }
}

