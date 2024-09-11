import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../driver push notification/push_notification_system.dart';
import '../global/global_variable.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {


  double bottomMapPadding = 0;
  Set<Marker> currentLocationMarkers = {};

  GoogleMapController? controllerGoogleMap;
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();


  var geoLocator = Geolocator();

  LocationPermission? _locationPermission;

  String statusText = "now offline";
  Color buttonColor = Colors.grey;
  bool isDriverActive = false;

  checkIfLocationPermissionAllowed() async{
    _locationPermission = await Geolocator.requestPermission();
    if(_locationPermission == LocationPermission.denied){
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  addMarker2(LatLng position) {
    currentLocationMarkers = {
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude),
        infoWindow: InfoWindow(
          title: 'Your Driver Current Location',
        ),
      ),
    };
  }


  void updateMapTheme(GoogleMapController controller)
  {
    getJsonFileFromThemes("themes/night_style.json").then((value)=>setGoogleMapStyle(value,controller));
  }

  Future<String> getJsonFileFromThemes(String mapStylePath) async
  {
    ByteData byteData = await rootBundle.load(mapStylePath);
    var list = byteData.buffer.asUint8List(byteData.offsetInBytes,byteData.lengthInBytes);
    return utf8.decode(list);
  }

  setGoogleMapStyle(String googleMapStyle, GoogleMapController controller)
  {
    controller.setMapStyle(googleMapStyle);
  }

  locateDriverPosition() async
  {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    driverCurrentPosition = positionOfUser;

    LatLng positionOfUserInLatLng = LatLng(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(
        target: positionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));

    addMarker2(LatLng(driverCurrentPosition!.latitude,driverCurrentPosition!.longitude),);
  }

  readCurrentDriverInformation() async
  {
    currentUser = firebaseAuth.currentUser;
    FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).once().then((snap)
    {
      if(snap.snapshot.value != null) {
        onlineDriverData.id = (snap.snapshot.value as Map)["id"];
        onlineDriverData.name = (snap.snapshot.value as Map)["name"];
        onlineDriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlineDriverData.email = (snap.snapshot.value as Map)["email"];
        onlineDriverData.address = (snap.snapshot.value as Map)["address"];
        onlineDriverData.car_model = (snap.snapshot.value as Map)["car_details"]["car_model"];
        onlineDriverData.car_number = (snap.snapshot.value as Map)["car_details"]["car_number"];
        onlineDriverData.car_color = (snap.snapshot.value as Map)["car_details"]["car_color"];
        onlineDriverData.car_type = (snap.snapshot.value as Map)["car_details"]["type"];

        driversVehicleType = (snap.snapshot.value as Map)["car details"]["type"];
      }

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfLocationPermissionAllowed();
    readCurrentDriverInformation();

    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          GoogleMap(
            padding:  EdgeInsets.only(top: 26,bottom: bottomMapPadding),
            mapType: MapType.hybrid,
            myLocationEnabled: true,
            markers:currentLocationMarkers ,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController)
            {
              controllerGoogleMap = mapController;
              updateMapTheme(controllerGoogleMap!);
              googleMapCompleterController.complete(controllerGoogleMap);

              setState(() {
                bottomMapPadding = 350;
              });


              locateDriverPosition();



            },

          ),

          //ui for online/offline driver
          statusText != "now online"
              ? Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: Colors.black87,
          ): Container(),

          //button for online/offline driver
          Positioned(
            top: statusText!= "now online"? MediaQuery.of(context).size.height * 0.45 :40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: (){
                      if(isDriverActive != true)
                      {
                        driverIsOnlineNow();
                        updateDriversLocationAtRealTime();

                        setState(() {
                          statusText = "now online";
                          isDriverActive = true;
                          buttonColor = Colors.transparent;
                        });
                      }
                      else{
                        driverIsOfflineNow();
                        setState(() {
                          statusText = "now offline";
                          isDriverActive = false;
                          buttonColor = Colors.grey;
                        });
                        Fluttertoast.showToast(msg: "you are offline now");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: buttonColor,
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius:BorderRadius.circular(26),
                      ),
                    ),
                    child: statusText != "now online" ? Text(statusText,
                      style:TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ):Icon(
                      Icons.phonelink_ring,
                      color: Colors.white,
                      size: 26,
                    )
                )
              ],
            ),
          )



        ],

      ),


    );
  }


  driverIsOnlineNow() async{
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high
    );
    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(currentUser!.uid,driverCurrentPosition!.latitude,driverCurrentPosition!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("newRideStatus");

    ref.set("idle");
    ref.onValue.listen((event) { });
  }

  updateDriversLocationAtRealTime()
  {
    streamSubscriptionPosition = Geolocator.getPositionStream().listen((Position position){
      if(isDriverActive == true){
        Geofire.setLocation(currentUser!.uid,driverCurrentPosition!.latitude,driverCurrentPosition!.longitude);
      }
      LatLng latlng = LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

      controllerGoogleMap!.animateCamera(CameraUpdate.newLatLng(latlng));

    });
  }

  driverIsOfflineNow()
  {
    Geofire.removeLocation(currentUser!.uid);

    DatabaseReference? ref = FirebaseDatabase.instance.ref().child("drivers").child(currentUser!.uid).child("newRideStatus");

    ref.onDisconnect();
    ref.remove();
    ref = null;

    Future.delayed(Duration(milliseconds: 9000),(){
      SystemChannels.platform.invokeMapMethod("Navigator.push(context,MaterialPageRoute(builder: (c) =>SecondPage()))");
    });
  }

}
