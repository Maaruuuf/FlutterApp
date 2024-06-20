
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../driver model/user_ride_request_information.dart';
import '../global/global_variable.dart';
import 'notification_dialogue_box.dart';

class PushNotificationSystem{
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async{

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage){
      if(remoteMessage != null){
        readUserRideRequestInformation(remoteMessage.data["rideRequestId"],context);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage){
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"],context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"],context);
    });

  }

  readUserRideRequestInformation(String userRideRequestId,BuildContext context) {
    FirebaseDatabase.instance.ref().child("All Ride Request").child(userRideRequestId).child("driverId").onValue.listen((event) {
      if (event.snapshot.value == "waiting" || event.snapshot.value == firebaseAuth.currentUser!.uid) {
        FirebaseDatabase.instance.ref().child("All Ride Request").child(userRideRequestId).once().then((snapData) {
          if (snapData.snapshot.value != null) {
            double originlat = double.parse((snapData.snapshot.value! as Map)["origin"]["latitude"]);
            double originlng = double.parse((snapData.snapshot.value! as Map)["origin"]["longitude"]);
            String originAddress = (snapData.snapshot.value! as Map)["originAddress"];
            //double destinationlat = double.parse((snapData.snapshot.value! as Map) ["destination"]["latitude"]);
            //double destinationlng = double.parse((snapData.snapshot.value! as Map)["destination"]["longitude"]);
            // String destinationAddress = (snapData.snapshot.value! as Map)["destinationAddress"];
            String userName = (snapData.snapshot.value! as Map)["userName"];
            //String userPhone = (snapData.snapshot.value! as Map) ["userPhone"];
            String? rideRequestId = snapData.snapshot.key;

            UserRideRequestInformation userRideRequestDetails = UserRideRequestInformation();
            userRideRequestDetails.originLatLng = LatLng(originlat, originlng);
            userRideRequestDetails.originAddress = originAddress;
            //userRideRequestDetails.destinationLatLng = LatLng(destinationlat, destinationlng);
            // userRideRequestDetails.destinationAddress = destinationAddress;
            userRideRequestDetails.userName = userName;
            // userRideRequestDetails.userPhone = userPhone;

            userRideRequestDetails.rideRequestId = rideRequestId;

            showDialog(
                context: context,
                builder: (BuildContext context) => NotificationDialogBox(
                  userRideRequestDetails: userRideRequestDetails,
                )
            );
          }
          else{
            Fluttertoast.showToast(msg: "This Ride Request Id do not exists.");
          }
        });
      }
      else{
        Fluttertoast.showToast(msg: "This Ride Request has been cancelled");
        Navigator. pop(context);

      }
    });
  }

  Future generateAndGetToken()async {
    String? registrationToken = await messaging.getToken();

    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("token")
        .set (registrationToken);

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");

  }

}