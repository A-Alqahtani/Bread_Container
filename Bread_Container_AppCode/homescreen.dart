import 'dart:io';

import 'package:breadbox/screens/createlocationlink.dart';
import 'package:breadbox/screens/adminreadscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'createscreen.dart';
import 'deletescreen.dart';
import 'readscreen.dart';
import 'updatescreen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Center(child: Text('Smart Bread Container')),
    CreateLocationLinkScreen(),
    UpdatedLocationScreen(),
    UpdateScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _logoutAndCloseApp(BuildContext context) async {
    // Perform the logout logic
    await auth.signOut();

    // Close the app
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: Colors.brown,),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add,color: Colors.brown,),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search,color: Colors.brown,),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit,color: Colors.brown,),
            label: 'Edit',
          ),
        ],
      ),
    );
  }
}
