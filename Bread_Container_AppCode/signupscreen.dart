import 'package:breadbox/main.dart';
import 'package:breadbox/screens/loginscreen.dart';
import 'package:breadbox/screens/adminreadscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global.dart';
import '../userscreens/readscreen.dart';
import '../widgets/progress_dialog.dart';
import 'homescreen.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController nameTextEditingConrtroller= TextEditingController();
  TextEditingController emailTextEditingConrtroller= TextEditingController();
  TextEditingController passwordTextEditingConrtroller= TextEditingController();
  TextEditingController phoneTextEditingConrtroller= TextEditingController();
  validateForm()
  {
    if(nameTextEditingConrtroller.text.length < 3)
    {
      Fluttertoast.showToast(msg: "name must be atleast 3 Characters.");
    }
    else if(!emailTextEditingConrtroller.text.contains("@"))
    {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    }
    else if(passwordTextEditingConrtroller.text.length < 6)
    {
      Fluttertoast.showToast(msg: "Password must be atleast 6 Characters.");
    }
    else
    {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          return ProgressDialog(message: "Processing, Please wait...",);
        }
    );
    final User? firebaseUser = (
        await fAuth.createUserWithEmailAndPassword(
          email: emailTextEditingConrtroller.text.trim(),
          password: passwordTextEditingConrtroller.text.trim(),
        ).catchError((msg){
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Error: " + msg.toString());
        })
    ).user;
    if(firebaseUser != null)
    {
      Map userMap =
      {
        "id": firebaseUser.uid,
        "name": nameTextEditingConrtroller.text.trim(),
        "email": emailTextEditingConrtroller.text.trim(),

      };
      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).set(userMap);

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.brown.shade600, // Choose a color that complements the background
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFEAC086), Color(0xFFC89F78)],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded( // Add Expanded widget
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 60.0),
                            TextFormField(
                              controller: nameTextEditingConrtroller,
                              style: TextStyle(
                                color: Colors.brown
                              ),
                              decoration: InputDecoration(
                                labelText: 'Full Name',
                                prefixIcon: Icon(Icons.person, color: Colors.grey),
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: emailTextEditingConrtroller,
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
                              controller: passwordTextEditingConrtroller,
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
                                // Implement signup logic here
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.brown, // Button color matching the background
                              ),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white, // Button text color
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextButton(
                              onPressed: () {
                                // Navigate back to login page
                                Navigator.push(context, MaterialPageRoute(builder: (c) => LoginPage()));
                              },
                              child: Text(
                                'Already have an account? Login',
                                style: TextStyle(
                                  color: Colors.brown, // Text color matching the background
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
