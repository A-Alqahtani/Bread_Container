import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'homescreen.dart';
import 'adminreadscreen.dart';

class UpdateScreen extends StatefulWidget {
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final DatabaseReference databaseReference =
  FirebaseDatabase.instance.reference().child('boxes');

  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController locationLinkController = TextEditingController();
  final TextEditingController locationnameController = TextEditingController();
  String? selectedBoxNumber; // Store the selected box number


  // Define a list to store the box numbers
  List<String> boxNumbers = [];

  @override
  void initState() {
    super.initState();
    // Fetch the list of box numbers when the screen initializes
    fetchBoxNumbers();
  }

  void fetchBoxNumbers() {
    databaseReference.get().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final numbers = data.keys.toList().map((key) => key.toString()).toList();
        setState(() {
          boxNumbers = numbers;
        });
      }
    }).catchError((error) {
      // Handle any errors that occurred during the fetch
      print('Error fetching box numbers: $error');
    });
  }



  void updateLocation() {
    final double latitude = double.tryParse(latitudeController.text) ?? 0.0;
    final double longitude = double.tryParse(longitudeController.text) ?? 0.0;
    String locationLink = locationLinkController.text;
    String locationname = locationnameController.text;
    if (selectedBoxNumber!.isEmpty) {
      // Show an error message if no box number is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a box number.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Update the location data in the database for the selected box number
    databaseReference
        .child(selectedBoxNumber!)
        ..update({
          'location': {
            'mapurl': locationLink,
            //'longitude': longitude,
          },
          'status': 'full',
          'locationname':locationname,
      // 'longitude': longitude,
    },).then((_) {
      // Clear the text fields after updating
      latitudeController.clear();
      longitudeController.clear();
      locationLinkController.clear();
      selectedBoxNumber = ''; // Reset the selected box number

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Location updated successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      // Handle any errors that occurred during the update
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating location: $error'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Location'),
        backgroundColor: Colors.brown.shade600,
        actions: [
          IconButton(
            icon: Icon(Icons.home_filled, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => UpdatedLocationScreen()));
            },
          ),
        ],
      ),
      backgroundColor: Colors.brown[100],
      body:Stack(
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
                DropdownButton<String>(
                  value: selectedBoxNumber, // Make sure this value is valid and unique
                  hint: Text('Select a Container Number'),
                  onChanged: (newValue) {
                    setState(() {
                      selectedBoxNumber = newValue!;
                    });
                  },
                  items: boxNumbers.map((boxNumber) {
                    return DropdownMenuItem<String>(
                      value: boxNumber, // Each value should be unique and valid
                      child: Text(boxNumber),
                    );
                  }).toList(),
                ),


                TextField(
                  controller: locationLinkController,
                  keyboardType: TextInputType.text, // Allow only numeric input
                  decoration: InputDecoration(labelText: 'google map url'),
                ),

                const SizedBox(height: 20),
                TextField(
                  controller: locationnameController,
                  decoration: const InputDecoration(
                      labelText: 'Near to location'),
                ),
                ElevatedButton(
                  onPressed: updateLocation,
                  child: Text('Update Location'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.brown),
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
