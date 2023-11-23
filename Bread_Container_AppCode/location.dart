import 'package:flutter/material.dart';
class LiveLocation extends StatefulWidget {
  const LiveLocation({Key? key}) : super(key: key);

  @override
  State<LiveLocation> createState() => _LiveLocationState();
}

class _LiveLocationState extends State<LiveLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Conatiner Live Location"),
        backgroundColor: Colors.brown.shade600,
      ),
    );
  }
}
