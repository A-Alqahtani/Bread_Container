import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../model/user_model.dart';







StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;

UserModel? userModelCurrentInfo;
List dList =[]; // driver key info
String? chosenDriverId="";
String userDropOfAddress ="";
String cloudMessagingServerToken = "key=AAAAH1NcDwU:APA91bFZQrywkkwApNGN_9xhIAaK-YzFLCyMqSs-XHZOL_ulGTqmtWIJljurUqrZ_jQ7qZ-DW9ybNe6XhTzGOgU67RJ77ZW27GmMg8M6obLkpZNelpmNrB0hYSNyjFdQFkiSGJC9tuNU";
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
double countRatingStars=0.0;
String titleStarsRating="";
bool isDriverActive = false;
String statusText = "Now Offline";
Color buttonColor = Colors.blue;