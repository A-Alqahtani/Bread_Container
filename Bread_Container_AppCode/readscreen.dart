import 'package:breadbox/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:url_launcher/url_launcher.dart';

class ReadScreen extends StatefulWidget {
  @override
  _ReadScreenState createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  final DatabaseReference databaseReference =
  FirebaseDatabase.instance.reference().child('boxes');

  List<int> boxNumbers = [];
  Map<int, Map<dynamic, dynamic>> boxDataMap = {};

  @override
  void initState() {
    super.initState();

    // Listen for changes in the Firebase Realtime Database
    databaseReference.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data is Map) {
        final boxes = data.entries.where((entry) {
          final boxData = entry.value as Map<dynamic, dynamic>;
          // Replace with your condition (e.g., check status or location)
          // Example: return boxData['status'] == 'available';
          return true; // Include all boxes for now
        }).toList();

        setState(() {
          // Sort the boxes by box number in ascending order
          boxes.sort((a, b) {
            final boxNumberA = int.tryParse(a.key.replaceAll('box', '')) ?? 0;
            final boxNumberB = int.tryParse(b.key.replaceAll('box', '')) ?? 0;
            return boxNumberA - boxNumberB;
          });

          // Update the boxNumbers and boxDataMap
          boxNumbers = boxes.map<int>((box) {
            final boxNumber = int.tryParse(box.key.replaceAll('box', '')) ?? 0;
            return boxNumber;
          }).toList();
          boxDataMap = Map.fromIterable(
            boxes,
            key: (box) => int.tryParse(box.key.replaceAll('box', '')) ?? 0,
            value: (box) => box.value as Map<dynamic, dynamic>,
          );
        });
      }
    });
  }

  void deleteBox(int boxNumber) {
    // Delete the box with the given boxNumber from Firebase
    databaseReference.child('box$boxNumber').remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Read Data'),
        backgroundColor: Colors.brown.shade600,
      actions: [
        IconButton(icon: Icon(Icons.home_filled,color: Colors.white,),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
          },),
      ],
      ),

      body: ListView.builder(

        itemCount: boxNumbers.length,
        itemBuilder: (context, index) {
          final boxNumber = boxNumbers[index];
          final boxData = boxDataMap[boxNumber] ?? {};
          final status = boxData['status'] ?? '';
          final location = boxData['location'] ?? '';
          final latitude = location['latitude'] as double?;
          final longitude = location['longitude'] as double?;

          Color statusIndicatorColor = Colors.yellow; // Default color
          if (status == 'empty') {
            statusIndicatorColor = Colors.red;
          } else if (status == 'full') {
            statusIndicatorColor = Colors.green;
          }

          return ListTile(
            title: GestureDetector(
              onTap: () {
                // Open Google Maps with the specified latitude and longitude
                final mapUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
                launch(mapUrl).catchError((e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error launching Google Maps: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Box Number: $boxNumber',
                    style: TextStyle(
                      color: Colors.brown, // Make the text clickable
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete,color: Colors.red,),
                    onPressed: () {
                      // Delete the box when the delete icon is pressed
                      deleteBox(boxNumber);
                    },
                  ),
                ],
              ),
            ),
            subtitle: Row(
              children: [
                Text('Status: '),
                SizedBox(width: 16),
                CircleAvatar(
                  backgroundColor: statusIndicatorColor,
                  radius: 12,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


class LocationScreen extends StatelessWidget {
  final String location;

  LocationScreen({required this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location')),
      body: Center(
        child: Text('Location: $location'),
      ),
    );
  }
}
