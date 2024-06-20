import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:frist_project/models/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../driver model/driver_data.dart';


final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;
List driverList = [];

String userDropOffAddress ="";
String driverCarDetails = "";
String driverName ="";
String driverPhone="";
double countRatingStars = 0.0;
String titleStarsRating = "";
String cloudMessagingServerToken = "AAAAqdiu6PI:APA91bFajFaplCWD3DLHTW3-A5ZV1yAssuUe87NSOfMjXF7ZORm6au4MCZBQS3f3ZlfMydWy2En8xlU1ckc4KAt0qYSvld9uzVtIUfwmUpDpf6ir0hcGR7qOTvDtCMGTf-6ne2incTR7";

String userName = "";
String userEmail = "";
String userPhone = "";
String userAddress = "";
String googleMapKey = "AIzaSyBSGMNTVZwqcGsOxSB5aJDsKzrTxSUXqQ0";

 const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
  zoom: 14.4746,
);


class LocationWithPlace {
 LatLng coordinates;
 String placeName;

 LocationWithPlace(this.coordinates, this.placeName);
}

Position? driverCurrentPosition;
String? driversVehicleType = "";

DriverData onlineDriverData = DriverData();
UserModel userModelCurrentInfo = UserModel();

StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>?streamSubscriptionDriverLivePosition;

