import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'homescreen.dart';

class CreateScreen extends StatefulWidget {
  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final DatabaseReference databaseReference =
  FirebaseDatabase.instance.reference().child('boxes');

  final TextEditingController statusController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController boxNumberController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();

  void createBox() {
    final double latitude = double.tryParse(latitudeController.text) ?? 0.0;
    final double longitude = double.tryParse(longitudeController.text) ?? 0.0;
    final String boxNumber = boxNumberController.text;
    final String status = statusController.text;

    // Update both location and status fields for the specified box number
    databaseReference
        .child('box$boxNumber')
        .update({
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
      'status': status,
    })
        .then((_) {
      // Clear the text fields after updating
      latitudeController.clear();
      longitudeController.clear();
      boxNumberController.clear();
      statusController.clear();

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location and Status updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    })
        .catchError((error) {
      // Handle any errors that occurred during the update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating location and status: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Container'),
        backgroundColor: Colors.brown.shade600,
        actions: [
          IconButton(icon: const Icon(Icons.home_filled,color: Colors.white,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
            },),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: boxNumberController,
              decoration: const InputDecoration(labelText: 'Container Number'),
            ),
            TextField(
              controller: statusController,
              decoration: const InputDecoration(labelText: 'Status'),
            ),
            TextField(
              controller: latitudeController,
              decoration: const InputDecoration(labelText: 'latitude'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: longitudeController,
              decoration: const InputDecoration(labelText: 'longitude'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createBox,
              child: const Text('Create'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
