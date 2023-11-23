import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class DeleteScreen extends StatefulWidget {
  @override
  _DeleteScreenState createState() => _DeleteScreenState();
}

class _DeleteScreenState extends State<DeleteScreen> {
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
      appBar: AppBar(title: Text('Delete Boxes')),
      body: ListView.builder(
        itemCount: boxNumbers.length,
        itemBuilder: (context, index) {
          final boxNumber = boxNumbers[index];
          final boxData = boxDataMap[boxNumber] ?? {};
          return ListTile(
            title: Text('Box Number: $boxNumber'),
            subtitle:
            Text('Status: ${boxData['status'] ?? ''}, Location: ${boxData['location'] ?? ''}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Prompt the user for confirmation or perform the delete action directly
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Delete Box'),
                      content: Text('Are you sure you want to delete Box Number $boxNumber?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            // Delete the box
                            deleteBox(boxNumber);
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
