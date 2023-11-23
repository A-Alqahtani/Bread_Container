import 'dart:convert';

import 'package:breadbox/methods/request_assistant.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';


import '../global/global.dart';
import '../global/map_key.dart';
import '../model/user_model.dart';








class AssistantMethods
{
  static Future<String> searchAddressForGeographicCoOrdinates(Position position,context) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey1";
    String humanReadableAddress="";
    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    return humanReadableAddress;

  }
  static void readCurrentOnlineUserInfo() async
  {
    currentFirebaseUser = fAuth.currentUser;

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    userRef.once().then((snap)
    {
      if(snap.snapshot.value != null)
      {
        userModelCurrentInfo = UserModel .fromSnapshot(snap.snapshot);

      }
    });
  }




  //retrieve the trips KEYS for online user
  //trip key = ride request key



}