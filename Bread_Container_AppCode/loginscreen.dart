

import 'package:breadbox/main.dart';
import 'package:breadbox/screens/readscreen.dart';

import 'package:breadbox/screens/signupscreen.dart';
import 'package:breadbox/screens/adminreadscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../userscreens/readscreen.dart';
import '../userscreens/userhomescreen.dart';
import '../widgets/progress_dialog.dart';
import 'homescreen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required.");
    } else {
      loginUserNow();
    }
  }

  loginUserNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(message: "Processing, Please wait...");
      },
    );

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      );
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        // Authentication successful
        currentFirebaseUser = firebaseUser;

        if (firebaseUser.email == "admin@gmail.com") {
          // Navigate to HomeScreen for admin
          Fluttertoast.showToast(msg: "Login Successful as Admin.");
          Navigator.push(context, MaterialPageRoute(builder: (c) => UpdatedLocationScreen()));
        } else {
          // Navigate to NewHomeScreen for non-admin users
          Fluttertoast.showToast(msg: "Login Successful.");
          Navigator.push(context, MaterialPageRoute(builder: (c) => UserReadScreen()));
        }
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(msg: "Error Occurred during Login.");
      }
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
        backgroundColor: Colors.brown.shade600, // Choose a color that complements the background
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAC086), Color(0xFFC89F78)], // Customize your gradient colors
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: emailTextEditingController,
                  style: TextStyle(
                    color: Colors.brown, // Text color matching the background
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),

                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordTextEditingController,
                  style: TextStyle(
                    color: Colors.brown, // Text color matching the background
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,

                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    validateForm();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.brown, // Button color matching the background
                  ),
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white, // Button text color
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => SignupPage()));
                  },
                  child: Text(
                    'Don\'t have an account? Sign up',
                    style: TextStyle(
                      color: Colors.brown, // Text color matching the background
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),

      ),
    );
  }
}



