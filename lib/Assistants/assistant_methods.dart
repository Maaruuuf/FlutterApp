import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/Assistants/request_assistant.dart';
import 'package:frist_project/models/directions.dart';
import 'package:frist_project/models/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../global/global_variable.dart';
import '../info_handler/app_info.dart';
import 'package:http/http.dart' as http ;





class AssistantMethods {

  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);

    usersRef.once().then((snap){
      if(snap.snapshot.value != null){
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
  }

  static Future<String> searchAddressForGeographicCoordinates(Position position,context) async
  {
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleMapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occured. Failed. No Response. "){

      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);

    }

    return humanReadableAddress;

  }

  static sendNotificationToDriverNow(String deviceRegistrationToken,String userRideRequestId,context) async {
    String destinationAddress = userDropOffAddress;

    Map<String,String>headerNotification = {
      'content-Type':'application/json',
      'Authorization': cloudMessagingServerToken,
    };

    Map bodyNotification = {
      "body":"Destination Address: \n $destinationAddress",
      "title":"New Trip Request"
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status":"done",
      "rideRequestId":userRideRequestId

    };

    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "data":dataMap,
      "priority":"high",
      "to":deviceRegistrationToken,
    };



    var responseNotifation = http.post(
      Uri.parse("http://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat),
    );
  }



}