
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frist_project/driver%20assistant%20methods/driver_assistant_methods.dart';
import '../driver mainscreen/newtrip_screen.dart';
import '../driver model/user_ride_request_information.dart';
import '../global/global_variable.dart';


class NotificationDialogBox extends StatefulWidget {

  UserRideRequestInformation? userRideRequestDetails;
  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape:
      RoundedRectangleBorder(
        borderRadius: BorderRadius. circular (24),
      ),
      backgroundColor: Colors. transparent,
      elevation: 0,
      child: Container(
        margin: EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius. circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              onlineDriverData.car_type == " Car1" ? "assets/images/driver_car.png"
                  : onlineDriverData.car_type == " Car2" ? "assets/images/driver_car2.png"
                  : "assets/images/driver_car3.png",
            ), // Image.asset
            SizedBox(height: 10,),
            //title
            Text("New Ride Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 14,),

            Divider(
              height: 2,
              thickness: 2,
              color: Colors.blue,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset("assets/images/initial.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10,),

                      Expanded(
                        child:Container(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),
                  Row(
                    children: [
                      Image.asset("assets/images/destination.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(width: 10,),

                      Expanded(
                        child:Container(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),

                ],
              ),
            ),
            Divider(
              height: 2,
              thickness: 2,
              color: Colors.blue,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  SizedBox(width: 20,),
                  ElevatedButton(
                    onPressed: (){
                      acceptRideRequest(context);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.green,
                    ),
                    child: Text(
                      "Accept".toUpperCase(),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),

            ),
          ],
        ),
      ),
    );
  }
  acceptRideRequest(BuildContext context)
  {
    FirebaseDatabase.instance.ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child ("newRideStatus")
        .once()
        .then ((snap)
    {
      if(snap.snapshot.value == "idle"){
        FirebaseDatabase.instance.ref().child("drivers").child(firebaseAuth.currentUser!.uid).child("newRideStatus").set("accepted");
        DriverAssistantMethods.pauseLiveLocationUpdates();

        Navigator.push(context,MaterialPageRoute(builder:(c) => NewTripScreen()));

      }
      else
      {
        Fluttertoast.showToast(msg: "this ride request not exist");
      }

    });
  }

}
