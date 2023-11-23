import 'package:breadbox/screens/adminreadscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'homescreen.dart';
import 'package:url_launcher/url_launcher.dart';

class SetContactusScreen extends StatefulWidget {
  @override
  _SetContactusScreenState createState() =>
      _SetContactusScreenState();
}

class _SetContactusScreenState extends State<SetContactusScreen> {
  final DatabaseReference databaseReference =
  FirebaseDatabase.instance.reference().child('contactus');

  final TextEditingController phonenumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void createBox() async {
    final String email = emailController.text;
    final String phonenumber = phonenumberController.text;

    try {


      // Update the location and status fields for the specified box number
      databaseReference.update({
        'email':email,
        'phonenumber': phonenumber,

      }).then((_) {
        // Clear the text fields after updating
        emailController.clear();
        phonenumberController.clear();

        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email and Phone Number updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      }).catchError((error) {
        // Handle any errors that occurred during the update
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating location and status: $error'),
            backgroundColor: Colors.red,
          ),
        );
      });
    } catch (e) {
      // Handle errors related to URL parsing or launching
      print('Error: $e');
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
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (c) => UpdatedLocationScreen()),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.brown[100],
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'images/containerbackground.jpg',

                ),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'admin email address'),
                ),
                // TextField(
                //   controller: statusController,
                //   decoration: const InputDecoration(labelText: 'Status'),
                // ),
                TextField(
                  controller: phonenumberController,
                  decoration: const InputDecoration(
                      labelText: 'phone_number'),
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: createBox,
                  child: const Text('Update '),
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.brown),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
