import 'package:flutter/material.dart';
class BoxLiveStatus extends StatefulWidget {
  const BoxLiveStatus({Key? key}) : super(key: key);

  @override
  State<BoxLiveStatus> createState() => _BoxLiveStatusState();
}

class _BoxLiveStatusState extends State<BoxLiveStatus> {
  // Define a variable to represent the container status (0 for empty, 50 for 50%, 100 for full)
  int containerStatus = 0; // Change this value as needed

  @override
  Widget build(BuildContext context) {
    // Determine the LED indicator color based on container status
    Color indicatorColor;
    if (containerStatus == 0) {
      indicatorColor = Colors.red;
    } else if (containerStatus == 50) {
      indicatorColor = Colors.yellow;
    } else {
      indicatorColor = Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Container Status'),
        backgroundColor: Colors.brown.shade600,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 50, // Adjust the size of the LED indicator
              height: 50, // Adjust the size of the LED indicator
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: indicatorColor,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Container Status',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

