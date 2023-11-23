import 'dart:async';


import 'package:breadbox/screens/loginscreen.dart';
import 'package:breadbox/screens/readscreen.dart';
import 'package:breadbox/screens/adminreadscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../methods/assistant_methods.dart';
import '../userscreens/readscreen.dart';






class Mysplashscreen extends StatefulWidget {

  @override
  _MysplashscreenState createState() => _MysplashscreenState();
}

class _MysplashscreenState extends State<Mysplashscreen> {
  void startTimer() {
    Timer(Duration(seconds: 3), () async {
      User? firebaseUser = fAuth.currentUser;

      if (await fAuth.currentUser != null && firebaseUser != null) {
        // Authentication successful
        currentFirebaseUser = firebaseUser;

        if (firebaseUser.email == "admin@gmail.com") {
          // Navigate to HomeScreen for admin
          Fluttertoast.showToast(msg: "Login Successful as Admin.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => UpdatedLocationScreen()),
          );
        } else {
          // Navigate to NewHomeScreen for non-admin users
          Fluttertoast.showToast(msg: "Login Successful.");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (c) => UserReadScreen()),
          );
        }
      } else {
        // User is not logged in, go to LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => LoginPage()),
        );
      }
    });
  }




  @override
  void initState() {
    super.initState();
    startTimer();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.black,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/Splash.jpg",fit:BoxFit.cover ,),

              ],
            )
        ),
      ),

    );
  }
}
