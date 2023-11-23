import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

import 'readscreen.dart';

class ContactInfo extends StatefulWidget {
  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.reference();
  String phoneNumber = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _fetchContactInfo();
  }

  void _fetchContactInfo() {
    _databaseReference.child('contactus').get().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        final Map<Object?, Object?>? data = snapshot.value as Map<Object?, Object?>?;
        if (data != null) {
          setState(() {
            phoneNumber = data['phonenumber']?.toString() ?? '';
            email = data['email']?.toString() ?? '';
          });
        }
      }
    }).catchError((error) {
      print("Error fetching data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // This extends the body behind the transparent app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Set the app bar's background to transparent
        elevation: 0, // Remove the elevation
        leading: TextButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (c) => UserReadScreen()));
          },
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all<TextStyle>(
              TextStyle(color: Colors.brown),
            ),
          ),
          child: Text("Home"),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/Contact us.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Contact Number Admin',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () => _launchDialer(phoneNumber),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: Colors.brown.shade600),
                      SizedBox(width: 5),
                      Text(
                        phoneNumber,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () => _launchEmail(email),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: Colors.brown.shade600),
                      SizedBox(width: 5),
                      Text(
                        email,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _launchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
