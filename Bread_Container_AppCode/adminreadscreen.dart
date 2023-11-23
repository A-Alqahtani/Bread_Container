import 'dart:io';

import 'package:breadbox/global/global.dart';
import 'package:breadbox/screens/setcontactinformation.dart';
import 'package:breadbox/screens/updatescreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:url_launcher/url_launcher.dart';

import 'createlocationlink.dart';
import 'loginscreen.dart';

class UpdatedLocationScreen extends StatefulWidget {
  @override
  _UpdatedLocationScreenState createState() => _UpdatedLocationScreenState();
}

class _UpdatedLocationScreenState extends State<UpdatedLocationScreen> {
  final DatabaseReference databaseReference =
  FirebaseDatabase.instance.reference().child('boxes');

  List<int> boxNumbers = [];
  Map<int, Map<dynamic, dynamic>> boxDataMap = {};

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();

    // Initialize Flutter local notifications
    initializeNotifications();

    // Listen for changes in the Firebase Realtime Database
    databaseReference.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        final boxes = data.entries.where((entry) {
          final boxData = entry.value as Map<dynamic, dynamic>;
          return true; // Include all boxes for now
        }).toList();

        setState(() {
          boxes.sort((a, b) {
            final boxNumberA = int.tryParse(a.key.replaceAll('box', '')) ?? 0;
            final boxNumberB = int.tryParse(b.key.replaceAll('box', '')) ?? 0;
            return boxNumberA - boxNumberB;
          });

          boxNumbers = boxes.map<int>((box) {
            final boxNumber = int.tryParse(box.key.replaceAll('box', '')) ?? 0;
            return boxNumber;
          }).toList();
          boxDataMap = Map.fromIterable(
            boxes,
            key: (box) => int.tryParse(box.key.replaceAll('box', '')) ?? 0,
            value: (box) => box.value as Map<dynamic, dynamic>,
          );

          // Schedule notifications for each box
          boxNumbers.forEach((boxNumber) {
            final status = boxDataMap[boxNumber]?['status'];
            if (status == 'full' || status == 'normal') {
              scheduleNotification(boxNumber, status);
            }
          });
        });
      }
    });
  }
  Future<void> scheduleNotification(int boxNumber, String status) async {
    String notificationText = '';
    if (status == 'full') {
      notificationText = 'The container number $boxNumber  is full. Please send someone to empty it!';
    } else if (status == 'normal') {
      notificationText = 'The container number  $boxNumber  is semi-full, be prepared to send someone in 2-3 days to empty it .';
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'bread Container', // Change to your channel ID
      'bread container', // Change to your channel name
      channelDescription:'get updated about your bread container', // Change to your channel description
      importance: Importance.max,
      priority: Priority.high,
    );
   
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Bread Container Status', // Notification Title
      notificationText, // Notification Body
      platformChannelSpecifics,
    );
  }
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  void deleteBox(int boxNumber) {
    databaseReference.child('box$boxNumber').remove();
  }

  void openGoogleMapsLocation(String locationLink) async {
    final mapUrl = locationLink;
    if (await canLaunch(mapUrl)) {
      await launch(mapUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error launching Google Maps.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
      // Navigate to the CreateLocationLinkScreen
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CreateLocationLinkScreen()),
        );
        break;
      case 1:
      // Navigate to the UpdateScreen
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => UpdateScreen()),
        );
        break;
      case 2:
      // Navigate to the UpdateScreen
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SetContactusScreen()),
        );
        break;
      default:
      // Navigate to a default screen if needed
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bread Container Locations'),
        backgroundColor: Colors.brown.shade600,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _showLogoutConfirmationDialog();
            },
          ),
        ],
      ),
      backgroundColor: Colors.brown[100],
      body: Stack(
        children: [
          Image.asset(
            'images/containerbackground.jpg',
            fit: BoxFit.cover, // You can adjust the fit as needed
            width: double.infinity,
            height: double.infinity,
          ),
          ListView.builder(

            itemCount: boxNumbers.length,
            itemBuilder: (context, index) {
              final boxNumber = boxNumbers[index];
              final boxData = boxDataMap[boxNumber] ?? {};
              final status = boxData['status'] ?? '';
              final locationname = boxData['locationname'] ?? '';
              final locationLink = boxData['location']?['mapurl'] ?? '';

              Color statusIndicatorColor = Colors.yellow; // Default color
              if (status == 'full') {
                statusIndicatorColor = Colors.red;
              } else if (status == 'empty') {
                statusIndicatorColor = Colors.green;
              }

              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  tileColor: Colors.white,
                  title: GestureDetector(
                    onTap: () {
                      // Open Google Maps with the specified location link
                      openGoogleMapsLocation(locationLink);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Container Number: $boxNumber',
                          style: TextStyle(
                            color: Colors.brown,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            // Delete the box when the delete icon is pressed
                            deleteBox(boxNumber);
                          },
                        ),
                      ],
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0), // Add padding here
                    child: Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          backgroundColor: statusIndicatorColor,
                          radius: 12,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Location: $locationname',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
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
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:Colors.brown.shade100,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          _buildBottomNavItem(
            icon: Icons.add,
            label: 'New Container',
            color: Colors.brown,
          ),
          _buildBottomNavItem(
            icon: Icons.edit,
            label: 'Edit Container',
            color: Colors.brown,
          ),
          _buildBottomNavItem(
            icon: Icons.info,
            label: 'Edit Contact',
            color: Colors.brown,
          ),
        ],
      ),
    );
  }
  BottomNavigationBarItem _buildBottomNavItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.all(8.0), // Adjust padding as needed
        decoration: BoxDecoration(
          color: color.withOpacity(0.2), // Customize the background color
          borderRadius: BorderRadius.circular(10.0), // Customize the border radius
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      label: label,
    );
  }
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Do you want to sign out and exit the app?"),
          actions: [
            TextButton(
              child: Text("No",style: TextStyle(color: Colors.red),),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes",style: TextStyle(color: Colors.green),),
              onPressed: () {
                // Sign out the user
                _logoutAndCloseApp(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (c) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }

// Logout and exit the app
  void _logoutAndCloseApp(BuildContext context) async {
    // Perform the logout logic
    await fAuth.signOut();
//currentFirebaseUser=null;
    Navigator.of(context).popUntil((route) => route.isFirst);
    // Close the app
  }
}
