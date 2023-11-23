import 'dart:io';

import 'package:breadbox/userscreens/readscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final auth = FirebaseAuth.instance;
  void _logoutAndCloseApp(BuildContext context) async {
    // Perform the logout logic
    await auth.signOut();

    // Close the app
    exit(0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading:false,
        backgroundColor: Colors.brown.shade600,
        // title: Text('Firebase CRUD Example'),
        actions: [

          IconButton(
            icon: Icon(Icons.search,color: Colors.white,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => UserReadScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.logout,color: Colors.white,),
            onPressed: () {
              _logoutAndCloseApp(context);
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.delete),
          //   onPressed: () {
          //     Navigator.push(context, MaterialPageRoute(builder: (_) => DeleteScreen()));
          //   },
          // ),
        ],
      ),
      body: const Center(
        child:Text('Smart Bread Container'),
      ),
    );
  }
}
