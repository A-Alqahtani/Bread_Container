import 'package:flutter/material.dart';
class ContainerLiveLocation extends StatefulWidget {
  const ContainerLiveLocation({Key? key}) : super(key: key);

  @override
  State<ContainerLiveLocation> createState() => _ContainerLiveLocationState();
}

class _ContainerLiveLocationState extends State<ContainerLiveLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conatiner Location'),
      ),
    );
  }
}
