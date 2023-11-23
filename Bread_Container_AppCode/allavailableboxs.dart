import 'package:breadbox/screens/boxlivestatus.dart';
import 'package:breadbox/screens/location.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Box {
  late final int number;
  String status;
  String location;

  Box(this.number, {this.status = '', this.location = ''});
}

class BoxListScreen extends StatefulWidget {
  @override
  _BoxListScreenState createState() => _BoxListScreenState();
}

class _BoxListScreenState extends State<BoxListScreen> {
  final List<Box> boxes = [Box(1), Box(2), Box(3), Box(4), Box(5)]; // Example list of boxes

  @override
  void initState() {
    super.initState();
    // Initialize Firebase database reference
    final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

// Listen for changes in status for each box
    for (var box in boxes) {
      databaseReference.child('boxes').child('box${box.number}').child('status').onValue.listen((event) {
        final status = event.snapshot.value as String? ?? ''; // Explicit cast to String
        setState(() {
          box.status = status;
        });
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Box List'),
        backgroundColor: Colors.brown.shade600, // Match the color to LoginPage
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add a new box
              final newBoxNumber = boxes.length + 1;
              addBoxToDatabase(newBoxNumber);

              // Update the local state to reflect the new box
              setState(() {
                boxes.add(Box(newBoxNumber));
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEAC086), Color(0xFFC89F78)],
          ),
        ),
        child: ListView.builder(
          itemCount: boxes.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Box ${boxes[index].number}',
                          style: TextStyle(
                            color: Colors.brown, // Match text color to LoginPage
                          ),
                        ),
                        SizedBox(width: 10.0), // Adjust the spacing here
                        Container(
                          width: 15, // Adjust the size of the LED indicator
                          // height: 15, // Adjust the size of the LED indicator
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getIndicatorColor(boxes[index].status),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red, // Match icon color to LoginPage
                      ),
                      onPressed: () {
                        // Delete the box from the database and update the local state
                        final boxNumber = boxes[index].number;
                        deleteBoxFromDatabase(boxNumber);
                        setState(() {
                          boxes.removeAt(index);
                          // Update the numbering of the remaining boxes
                          for (int i = index; i < boxes.length; i++) {
                            boxes[i].number = i + 1;
                          }
                        });
                      },
                    ),

                  ],
                ),
                onTap: () {
                  _showBoxDialog(context, boxes[index]);
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getIndicatorColor(String status) {
    if (status.isEmpty) {
      return Colors.red;
    } else if (status == '50') {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  void addBoxToDatabase(int boxNumber) {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    // Create a new box entry in the database
    databaseReference.child('boxes').child('box$boxNumber').set({
      'status': '',
      'location': '',
    });
  }

  void deleteBoxFromDatabase(int boxNumber) {
    final DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    // Delete the box entry from the database
    databaseReference.child('boxes').child('box$boxNumber').remove();
  }

  Future<void> _showBoxDialog(BuildContext context, Box box) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Box ${box.number}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => BoxLiveStatus()));
                  // Handle "Box Location" button

                  // Handle "Check Status" button
                },
                child: const Text(
                  'Check Status',
                  style: TextStyle(
                    color: Colors.brown, // Match button text color to LoginPage
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => LiveLocation()));
                  // Handle "Box Location" button
                },
                child: const Text(
                  'Box Location',
                  style: TextStyle(
                    color: Color(0xFFBD6E63), // Match button text color to LoginPage
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

