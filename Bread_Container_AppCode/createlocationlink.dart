import 'package:breadbox/screens/adminreadscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'homescreen.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateLocationLinkScreen extends StatefulWidget {
  @override
  _CreateLocationLinkScreenState createState() =>
      _CreateLocationLinkScreenState();
}

class _CreateLocationLinkScreenState extends State<CreateLocationLinkScreen> {
  final DatabaseReference databaseReference =
  FirebaseDatabase.instance.reference().child('boxes');

  final TextEditingController statusController = TextEditingController();
  final TextEditingController boxNumberController = TextEditingController();
  final TextEditingController locationLinkController = TextEditingController(); // Controller for the location link
  final TextEditingController locationnamecontroller = TextEditingController();
  void createBox() async {
    final String boxNumber = boxNumberController.text;
    final String status = statusController.text;
    final String locationLink = locationLinkController.text;
    final String locationname = locationnamecontroller.text;
    try {
      final Uri locationUri = Uri.parse(locationLink);
      // if (await canLaunch(locationLink)) {
      //   await launch(locationLink);
      // }

      // Wait for the user to return to the app after opening the link (optional).
      // You can skip this if not needed.
      await Future.delayed(Duration(seconds: 2));

      // After returning from Google Maps, retrieve the current location
      // (latitude and longitude) and update the database.
      // This is a simplified example, and you may need to use additional plugins
      // or APIs to achieve this functionality.

      // For example, you can use a location package like 'geolocator' to fetch
      // the user's current location.

      // Set dummy values for latitude and longitude for demonstration purposes.
      final double latitude = 37.7749; // Replace with actual latitude
      final double longitude = -122.4194; // Replace with actual longitude

      // Update the location and status fields for the specified box number
      databaseReference.child('box$boxNumber').update({
        'location': {
          'mapurl': locationLink,
          //'longitude': longitude,
        },
        'status': 'full',
        'locationname':locationname,
      }).then((_) {
        // Clear the text fields after updating
        boxNumberController.clear();
        statusController.clear();
        locationLinkController.clear();
        locationnamecontroller.clear();
        // Show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location and Status updated successfully.'),
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
        title: const Text('Create New Container'),
        backgroundColor: Colors.brown.shade600,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.home_filled,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) =>  UpdatedLocationScreen()));
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
                  controller: boxNumberController,
                  decoration: const InputDecoration(labelText: 'Container Number'),
                ),
                // TextField(
                //   controller: statusController,
                //   decoration: const InputDecoration(labelText: 'Status'),
                // ),
                TextField(
                  controller: locationLinkController,
                  decoration: const InputDecoration(
                      labelText: 'Location Link (Google Maps)'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: locationnamecontroller,
                  decoration: const InputDecoration(
                      labelText: 'Near to location'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: createBox,
                  child: const Text('Create'),
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
