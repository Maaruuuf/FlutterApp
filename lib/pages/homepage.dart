import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frist_project/Assistants/assistant_methods.dart';
import 'package:frist_project/Assistants/geofire_assistant.dart';
import 'package:frist_project/aftersplash_second_page.dart';
import 'package:frist_project/authentication/login_screen.dart';
import 'package:frist_project/global/global_variable.dart';
import 'package:frist_project/models/activer_nearby_available_drivers.dart';
import 'package:frist_project/pages/About_page.dart';
import 'package:frist_project/pages/History.dart';
import 'package:frist_project/pages/accepted_request_dialog.dart';
import 'package:frist_project/pages/location.dart';
import 'package:frist_project/pages/search_page.dart';
import 'package:frist_project/pages/visit_profile.dart';
import 'package:frist_project/splash_screen.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


import 'package:google_maps_webservice/directions.dart' as directions;
import 'package:provider/provider.dart';
import '../info_handler/app_info.dart';
import '../methods/common_methods.dart';
import 'package:location/location.dart' as loc;

import '../models/directions.dart';
import '../widgets/pay_fare_amount_dialog.dart';





class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPositionOfuser;
  Position? destinaionPositionOfuser;
  GlobalKey<ScaffoldState> skey = GlobalKey<ScaffoldState>();
  CommonMethods cMethods = CommonMethods();
  double bottomMapPadding = 0;
  bool openNavigationDrawer = true;
  bool activeNearByDriverKeysLoaded = false;
  Set<Marker> currentLocationMarkers = {};
  Set<Marker> destinationMarkers = {};
  Set<Marker> driversMarkers = {};
  Set<Polyline> polylines = {};
  Set<Marker>markersSet = {};
  Set<Circle>circlesSet ={};
  BitmapDescriptor? activeNearbyIcon;
  var geoLocation = Geolocator();
  LocationPermission? _locationPermission;
  String selectedVehicle ="";
  DatabaseReference? referenceRideRequest;

  double searchContainerHeight = 276;
  double suggestedRidesContainerHeight = 0;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverContainerHeight = 0;
  double searchForDriverContainerHeight=0;

  String driverRideStatus = "Driver is coming";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;
  String userRideRequestStatus = "";
  bool requestPositionInfo = true;

  String stAddress = "";
  String desAddress = "";

  List<ActiveNearByAvailableDrivers>onlineNearByAvailableDriversList=[];


  List<LatLng> dhakaLocations = [
    LatLng(23.763929, 90.406456), // Example aust 1
    LatLng(23.725819, 90.391898), // Example buet 2
    LatLng(23.739303, 90.402184), // Example ramnapark 3
    LatLng(23.732889, 90.393525), // Example du 4
    LatLng(23.8093, 90.3712), // Example mirpur 5
    LatLng(23.738526, 90.392578), // Example shahbag 6
    LatLng(23.7583, 90.3895), // Example farmgate 7
    LatLng(23.752190, 90.367697), // Example lalmatia 8
    LatLng(23.710273, 90.436894), // Example jatrabari 9
    LatLng(23.7613, 90.3664), // Example mohammadpur 10
    LatLng(23.723049, 90.414471), // motijheel 11
    LatLng(23.7932, 90.4143), // Gulshan  12
    LatLng(23.8759,90.3796), //uttara 13
  ];


  TextEditingController destinationController = TextEditingController();
  String _selectedLocationAddress = 'No location selected';

  LatLng selectedDestination = LatLng(0, 0);


  addMarker2(LatLng position) {
    currentLocationMarkers = {
      Marker(
        markerId: MarkerId('1'),
        position: LatLng(currentPositionOfuser!.latitude, currentPositionOfuser!.longitude),
        infoWindow: InfoWindow(
          title: 'My Pickup Location',
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

  getCurrentLiveLocationOfUser() async
  {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfuser = positionOfUser;

    LatLng positionOfUserInLatLng = LatLng(
        currentPositionOfuser!.latitude, currentPositionOfuser!.longitude);

    CameraPosition cameraPosition = CameraPosition(
        target: positionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition));


      addMarker2(LatLng(currentPositionOfuser!.latitude,currentPositionOfuser!.longitude),);





    print('my current location : ');
    print(currentPositionOfuser!.latitude.toString() +","+currentPositionOfuser!.longitude.toString());

    List<Placemark> placemarks = await placemarkFromCoordinates(currentPositionOfuser!.latitude,currentPositionOfuser!.longitude);

    setState(() {
      stAddress =placemarks.reversed.first.street.toString()+","+ placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString()+","+placemarks.reversed.last.country.toString();
    });



     await getUserInfoAndCheckBlockStatus();


    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;
    userPhone = userModelCurrentInfo!.phone!;

    print(userName);

    initializeGeoFireListener();
    //AssistantMethods.readTripsKeyForOnlineUser(context);

  }

  initializeGeoFireListener()
  {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(currentPositionOfuser!.latitude, currentPositionOfuser!.longitude, 10)!
    .listen((map) {
      print(map);
      if(map!=null) {
        var callBack = map["callBack"];
       switch(callBack) {
         case Geofire.onKeyEntered:
           ActiveNearByAvailableDrivers activeNearByAvailableDrivers = ActiveNearByAvailableDrivers();
           activeNearByAvailableDrivers.locationLatitude = map["latitude"];
           activeNearByAvailableDrivers.locationLongitude = map["longitude"];
           activeNearByAvailableDrivers.driverId = map["key"];
           GeoFireAssistant.activeNearByAvailableDriversList.add(activeNearByAvailableDrivers);
           if(activeNearByDriverKeysLoaded == true) {
             displayActiveDriversOnUserMap();
           }
           break;
         case Geofire.onKeyExited:
          GeoFireAssistant.deleteOfflineDriverFromList(map["key"]);
          displayActiveDriversOnUserMap();
          break;

         case Geofire.onKeyMoved:
           ActiveNearByAvailableDrivers activeNearByAvailableDrivers =ActiveNearByAvailableDrivers();
           activeNearByAvailableDrivers.locationLatitude = map["latitude"];
           activeNearByAvailableDrivers.locationLongitude = map["longitude"];
           activeNearByAvailableDrivers.driverId = map["key"];
           GeoFireAssistant.updateActiveNearByAvailableDriverLocation(activeNearByAvailableDrivers);
           displayActiveDriversOnUserMap();
           break;

         case Geofire.onGeoQueryReady:
           activeNearByDriverKeysLoaded = true;
           displayActiveDriversOnUserMap();
           break;

       }
      }

      setState(() {
        displayActiveDriversOnUserMap();


      });
    });
  }

  displayActiveDriversOnUserMap()
  {
    setState(() {

      // markersSet.clear();
      //circlesSet.clear();

      Set<Marker> driverMarkerSet = Set<Marker>();
      for(ActiveNearByAvailableDrivers eachDriver in GeoFireAssistant.activeNearByAvailableDriversList){
        LatLng eachDriverActivePosition  = LatLng(eachDriver.locationLatitude!,eachDriver.locationLongitude!);

        createActiveNearbyDriverIconMarkerPlus(eachDriverActivePosition);
        print(eachDriverActivePosition);



        Marker marker = Marker (
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );
       // driverMarkerSet.add(marker);
      }
      setState(() {
        markersSet = driverMarkerSet;
      });

    });


  }

  createActiveNearbyDriverIconMarker()
  {
    if(activeNearbyIcon == null)
    {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(context,size:Size(0.2,0.2));
      BitmapDescriptor.fromAssetImage(imageConfiguration,"assets/images/initial.png" ).then((value){
        activeNearbyIcon = value;
      });
    }

  }

  createActiveNearbyDriverIconMarkerPlus(LatLng eachDriverActivePosition){
    setState(() {
      driversMarkers = {
        Marker(
          markerId: MarkerId('15'),
          position: eachDriverActivePosition,
          infoWindow: InfoWindow(
            title: 'Driver Location',
          ),
        ),
      };
    });



  }

  void showSearchingForDriversContainer()
  {
    setState(() {
      searchForDriverContainerHeight = 300;
    });
  }

  showUIForAssignedDriverInfo()
  {
    setState(() {
      waitingResponseFromDriverContainerHeight = 0;
      searchContainerHeight = 0;
      assignedDriverContainerHeight = 0;
      suggestedRidesContainerHeight=0;
      bottomMapPadding=200;
    });
  }

  void showSuggestedRidesContainer()
  {
    setState(() {
      suggestedRidesContainerHeight = 400;
      bottomMapPadding = 400;


    });
  }


  getUserInfoAndCheckBlockStatus() async
    {

      DatabaseReference usersRef = FirebaseDatabase.instance.ref()
          .child("users")
          .child(FirebaseAuth.instance.currentUser!.uid);

      await usersRef.once().then((snap)
      {
        if(snap.snapshot.value != null)
        {
          if((snap.snapshot.value as Map)["blockStatus"]=="no")
          {
            setState(() {
              userName = (snap.snapshot.value as Map)["name"];
            });

          }
          else
          {
            FirebaseAuth.instance.signOut();
            Navigator.push(context,MaterialPageRoute(builder: (c) => LoginScreen()));
            cMethods.displaySnackBar("you are blocked...contact Admin", context);
          }

        }
        else
        {
          FirebaseAuth.instance.signOut();
          Navigator.push(context,MaterialPageRoute(builder: (c) => LoginScreen()));

        }
      });
    }

  saveRideRequestInformation(String selectedVehicle) {
    referenceRideRequest = FirebaseDatabase.instance.ref().child("All Ride Request").push();
    var originLocation = LatLng(currentPositionOfuser!.latitude, currentPositionOfuser!.longitude );

    Map originLocationMap = {
      "latitude": originLocation.latitude.toString(),
      "longitude": originLocation.longitude.toString(),
    };

    Map userInformationMap = {
      "origin": originLocationMap,
      "time": DateTime.now().toString(),
      "userName": userName, // Use null-aware operator and provide a default value if userModelCurrentInfo is null
      //"userPhone": userPhone, // Use null-aware operator and provide a default value if userModelCurrentInfo is null
      //"originAddress":originLocation.locationName,
      "driverId": "waiting",
    };

    referenceRideRequest!.set(userInformationMap);

    tripRideRequestInfoStreamSubscription = referenceRideRequest!.onValue.listen((eventSnap) async {
      if (eventSnap.snapshot.value == null) {
        return;
      }

      if ((eventSnap.snapshot.value as Map)["car_details"] != null) {
        setState(() {
          driverCarDetails = (eventSnap.snapshot.value as Map)["car_details"].toString();
        });
      }
      if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) {
        setState(() {
          driverCarDetails = (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }
      if ((eventSnap.snapshot.value as Map)["driverName"] != null) {
        setState(() {
          driverCarDetails = (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }
      if ((eventSnap.snapshot.value as Map)["status"] != null) {
        setState(() {
          userRideRequestStatus = (eventSnap.snapshot.value as Map)["status"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverLocation"] != null) {
        double driverCurrentPositionLat =
        double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["latitude"].toString());
        double driverCurrentPositionLng =
        double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["longitude"].toString());

        LatLng driverCurrentPositionLatLng = LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        if (userRideRequestStatus == "accepted") {
          updateArrivalTimeToUserPickuplocation(driverCurrentPositionLatLng);
        }

        if (userRideRequestStatus == "arrived") {
          setState(() {
            driverRideStatus = "Driver has Arrived";
          });
        }
        if (userRideRequestStatus == "ended") {
          if ((eventSnap.snapshot.value as Map)["fareAmount"] != null) {
            double fareAmount = double.parse((eventSnap.snapshot.value as Map)["fareAmount"].toString());

            var response = await showDialog(
              context: context,
              builder: (BuildContext context) => PayFareAmountDialog(
                fareAmount: fareAmount,
              ),
            );

            if (response == "Cash Paid") {
              if ((eventSnap.snapshot.value as Map)["driverId"] != null) {
                String assignedDriverId = (eventSnap.snapshot.value as Map)["driverId"].toString();
                //  Navigator.push(context, MaterialPageRoute(builder: (c) => RateDriverScreen()));

                referenceRideRequest!.onDisconnect();
                tripRideRequestInfoStreamSubscription!.cancel();
              }
            }
          }
        }
      }
    });


    onlineNearByAvailableDriversList = GeoFireAssistant.activeNearByAvailableDriversList;
    searchNearestOnlineDrivers(selectedVehicle);
    showSearchingForDriversContainer();

  }

  searchNearestOnlineDrivers(String selectedVehicle) async
  {
    /*if(onlineNearByAvailableDriversList.length == 0)
      {
        referenceRideRequest!.remove();
        setState(() {
          markersSet.clear();
        });

        Fluttertoast.showToast(msg: "No online nearest Driver available");


        Future.delayed(Duration(minutes: 3),(){
          referenceRideRequest!.remove();
          Navigator.push(context, MaterialPageRoute(builder:(c) => HomePage()));
        });
        return;
      } */
   await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);

    for(int i = 0; i < driverList.length;i++)
      {
        if(driverList[i]["car_details"]["type"] == selectedVehicle){
          AssistantMethods.sendNotificationToDriverNow(driverList[i]["token"],referenceRideRequest!.key!,context);
        }
      }
    Fluttertoast.showToast(msg: "Notification Sent Successfully");

   Future.delayed(Duration(milliseconds: 6000),(){
     Navigator.push(context,MaterialPageRoute(builder: (c) => AcceptedRequestDialog()));
   });

    //showSearchingForDriversContainer();

    await FirebaseDatabase.instance.ref().child("All Ride Request").child(referenceRideRequest!.key!).child("driverId").onValue.listen((eventRideRequestSnapshot){
      if(eventRideRequestSnapshot.snapshot.value != null)
        {
          if(eventRideRequestSnapshot.snapshot.value != "waiting"){
            showUIForAssignedDriverInfo();
          }
        }
    });

  }

  updateArrivalTimeToUserPickuplocation(driverCurrentPositionLatLng) async
  {
    if(requestPositionInfo == true){
      requestPositionInfo = false;
      LatLng userPickUpPosition = LatLng(currentPositionOfuser!.latitude,currentPositionOfuser!.longitude);

      setState(() {
        driverRideStatus = "Driver is Coming";
      });
      requestPositionInfo = true;
    }
  }


  retrieveOnlineDriversInformation(List onlineNearestDriversList) async
  {
   // driverList.clear();
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");

    for(int i=0;i<onlineNearestDriversList.length;i++)
      {
        await ref.child(onlineNearestDriversList[i].driverId.toString()).once().then((dataSnapshot) {
          var driverKeyInfo = dataSnapshot.snapshot.value;

          driverList.add(driverKeyInfo);
          print("driver key information" + driverList.toString());

        });
      }


  }


  void initState(){
    super.initState();
    getCurrentLiveLocationOfUser();
  }

  Future<String> getAddressFromLatLng(LatLng position) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark firstPlacemark = placemarks.first;
      String address = '${firstPlacemark.subThoroughfare ?? ''}  '
          '${firstPlacemark.subLocality ?? ''}, ${firstPlacemark.locality ?? ''}';

      return address.trim();
    } else {
      return 'No address available';
    }
  }

  void moveCamera(LatLng position) {
    if (controllerGoogleMap != null) {
      controllerGoogleMap!.animateCamera(
        CameraUpdate.newLatLngZoom(position, 14.0),
      );
    }
  }

  addMarker(LatLng position) {
    destinationMarkers = {
      Marker(
        markerId: MarkerId('2'),
        position: selectedDestination,
        infoWindow: InfoWindow(
          title: 'My Destination Location',
        ),
      ),
    };
  }




  void onDestinationSelected(LatLng destination) async {
    selectedDestination = destination;
    //addMarker(destination);
    if(selectedDestination == LatLng(23.763929, 90.406456))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.763929, 90.406456);

      setState(() {
        desAddress =placemarks.reversed.last.thoroughfare.toString()+","+ placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();

      });
      Position positionOfDestination = LatLng(23.763929, 90.406456) as Position;
      destinaionPositionOfuser = positionOfDestination;
      moveCamera(selectedDestination);
      //await drawPolyline(LatLng(currentPositionOfuser!.latitude, currentPositionOfuser!.longitude), destination);

    }
    else if(selectedDestination == LatLng(23.725819, 90.391898))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.725819, 90.391898);

      setState(() {
        desAddress =placemarks.reversed.last.thoroughfare.toString()+","+  placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }
    else if(selectedDestination == LatLng(23.739303, 90.402184))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.739303, 90.402184);

      setState(() {
        desAddress =placemarks.reversed.last.thoroughfare.toString()+","+ placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }
    else if(selectedDestination == LatLng(23.732889, 90.393525))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.732889, 90.393525);

      setState(() {
        desAddress =placemarks.reversed.first.street.toString()+","+  placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }
    else if(selectedDestination == LatLng(23.8093, 90.3712))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.8093, 90.3712);

      setState(() {
        desAddress =placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }
    else if(selectedDestination == LatLng(23.738526, 90.392578))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.738526, 90.392578);

      setState(() {
        desAddress =placemarks.reversed.last.thoroughfare.toString()+","+ placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }
    else if(selectedDestination == LatLng(23.7583, 90.3895))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.7583, 90.3895);

      setState(() {
        desAddress =placemarks.reversed.last.thoroughfare.toString()+","+ placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }
    else if(selectedDestination == LatLng(23.752190, 90.367697))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.752190, 90.367697);

      setState(() {
        desAddress =placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }
    else if(selectedDestination ==  LatLng(23.710273, 90.436894))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.710273, 90.436894);

      setState(() {
        desAddress = placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }
    else if(selectedDestination == LatLng(23.7613, 90.3664))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.7613, 90.3664);

      setState(() {
        desAddress =placemarks.reversed.last.thoroughfare.toString()+","+ placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }
    else if(selectedDestination ==  LatLng(23.723049, 90.414471))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.723049, 90.414471);

      setState(() {
        desAddress = placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }
    else if(selectedDestination == LatLng(23.7932, 90.4143))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.7932, 90.4143);

      setState(() {
        desAddress =placemarks.reversed.last.thoroughfare.toString()+","+ placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }
    else if(selectedDestination == LatLng(23.8759,90.3796))
    {
      addMarker(selectedDestination);
      List<Placemark> placemarks = await placemarkFromCoordinates(23.8759,90.3796);

      setState(() {
        desAddress = placemarks.reversed.last.subLocality.toString()+","+placemarks.reversed.last.locality.toString();
      });
    }


    String address = await getAddressFromLatLng(destination);
    setState(() {
      destinationController.text = address;
    });

    moveCamera(destination);
  }




  showDestinationSelector(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLocationPage(
          locations: dhakaLocations,
          onLocationSelected: (selectedLocation) {
            if (selectedLocation != null) {
              onDestinationSelected(selectedLocation);
            }
          },
        ),
      ),
    );
  }








  @override
  Widget build(BuildContext context) {

    createActiveNearbyDriverIconMarker();

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: skey,
        drawer: Container(
          width: 320,
          color: Colors.black87,
          child: Drawer(
            backgroundColor: Colors.white10,
            child: ListView(
              children: [


                Container(
                  color: Colors.black,
                  height: 200,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.black,

                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 100,
                        ),
                        const SizedBox(width: 25,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text(
                              userName,
                              style:const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Profile",
                              style: TextStyle(
                                color:Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const Divider(
                  height: 1,
                  color: Colors.white70,
                  thickness: 1,

                ),
                const SizedBox(height: 10,),

            GestureDetector(
              onTap: ()
              {
                Navigator.push(context,MaterialPageRoute(builder: (c) => Visitprofile()));
              },
              child: ListTile(
                  leading: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.person,color: Colors.white,),
                  ),
                  title: const Text("Visit Profile", style: TextStyle(color: Colors.white),),
                ),
            ),

            GestureDetector(
              onTap: ()
              {
                Navigator.push(context,MaterialPageRoute(builder: (c) => RideHistoryPage()));
              },
              child: ListTile(
                  leading: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.history,color: Colors.white,),
                  ),
                  title: const Text("History", style: TextStyle(color: Colors.white),),
                ),
            ),

            GestureDetector(
              onTap: ()
              {

                Navigator.push(context,MaterialPageRoute(builder: (c) => AboutPage()));
              },
              child: ListTile(
                  leading: IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.info,color: Colors.white,),
                  ),
                  title: const Text("About", style: TextStyle(color: Colors.white),),
                ),
            ),

                GestureDetector(
                  onTap: ()
                  {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context,MaterialPageRoute(builder: (c) => SecondPage()));
                  },
                  child: ListTile(
                    leading: IconButton(
                      onPressed: (){},
                      icon: const Icon(Icons.logout,color: Colors.white,),
                    ),
                    title: const Text("Logout", style: TextStyle(color: Colors.white),),
                  ),
                ),

              ],
            ),
          ),
        ),
        body: Stack(
          children: [

             GoogleMap(
              padding:  EdgeInsets.only(top: 26,bottom: bottomMapPadding),
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
               markers: Set<Marker>.of([...currentLocationMarkers, ...destinationMarkers,...driversMarkers]),
               polylines: polylines,
              initialCameraPosition: googlePlexInitialPosition,

              onMapCreated: (GoogleMapController mapController)
                {
                  controllerGoogleMap = mapController;
                  updateMapTheme(controllerGoogleMap!);
                  googleMapCompleterController.complete(controllerGoogleMap);

                  setState(() {
                    bottomMapPadding = 350;
                  });


                  getCurrentLiveLocationOfUser();
                  createActiveNearbyDriverIconMarker();


                },
            ),
            ///search location
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 320.0,
                decoration: const BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius:0.5,
                        offset: Offset(0.7,0.7),
                      ),
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6.0),
                      const Text("Hi there, ",style: TextStyle(fontSize: 15.0,color: Colors.black,fontWeight: FontWeight.bold),),
                      const Text("Where to ?  ",style: TextStyle(fontSize: 25.0,color: Colors.black,fontWeight: FontWeight.bold,fontFamily: "Brand-Bold"),),
                      const SizedBox(height: 20.0,),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6.0,
                              spreadRadius:0.5,
                              offset: Offset(0.7,0.7),
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(9.0),
                          child: Row(
                            children: [
                              Icon(Icons.search_sharp,color: Colors.blueAccent,),
                              SizedBox(width: 2.0,),
                              Text(
                                "Search Drop Off Location",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                      ),

                      const SizedBox(height: 15.0,),
                       Row(
                        children: [
                          Icon(Icons.home_filled,color: Colors.green,),
                          SizedBox(width: 5.0,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Pickup Address",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize:13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3.0,),
                              //Text("Your Home Address",style: TextStyle(color: Colors.white,fontSize: 9.0),),
                              Text(
                                stAddress,
                                style: TextStyle(
                                  color: Colors.black,
                                ),

                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5.0,),
                      const Divider(
                        height: 2,
                        color: Colors.white70,
                        thickness: 1,

                      ),
                      const SizedBox(height: 5.0,),

                       Padding(
                         padding: EdgeInsets.all(5),
                         child: GestureDetector(
                           onTap: () {
                             showDestinationSelector(context).then((selectedLocation) {
                               if (selectedLocation != null) {
                                 onDestinationSelected(selectedLocation);
                               }
                             });


                           },
                           child: Row(
                             children: [

                               Icon(Icons.work,color: Colors.blueGrey,),
                               SizedBox(width: 2.0,),
                               Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [

                                   Text(
                                     "Destination Address",
                                     style: TextStyle(
                                       color: Colors.black87,
                                       fontSize:13,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                   SizedBox(height: 4.0,),
                                   Text(
                                     desAddress.isNotEmpty ? desAddress : "Where to?",
                                     style: TextStyle(
                                       color: desAddress.isNotEmpty ? Colors.black : Colors.blueGrey,
                                       fontSize: desAddress.isNotEmpty ? null : 12.0,
                                       // Other style properties...
                                     ),
                                   ),
                                 ],
                               ),
                             ],
                           ),
                         ),
                       ),
                      SizedBox(height: 1,),
                      SizedBox(width: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: (){
                                showSuggestedRidesContainer();
                              },
                              child: Text("Request A Ride",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              ),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.blue[400],
                              textStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),




            ),


            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: suggestedRidesContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Text("Suggested Rides",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.blueGrey,
                        ),
                      ),
                      SizedBox(height: 10,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap:() {
                              setState(() {
                                selectedVehicle =" Car1";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedVehicle == " Car1" ? Colors.blue : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/driver_car.png",scale: 5,),

                                    SizedBox(height: 10,),

                                    Text(" Car1",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: selectedVehicle == " Car1" ? Colors.red :Colors.black,
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("৳ 100",
                                    style: TextStyle(
                                      color: Colors.red.shade900,
                                    ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap:() {
                              setState(() {
                                selectedVehicle =" Car2";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedVehicle == " Car2" ? Colors.blue : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/driver_car.png",scale: 5,),

                                    SizedBox(height: 10,),

                                    Text(" Car2",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: selectedVehicle == " Car2" ? Colors.red :Colors.black,
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("৳ 120",
                                      style: TextStyle(
                                        color: Colors.red.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                         /* GestureDetector(
                            onTap:() {
                              setState(() {
                                selectedVehicle =" Car3";
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: selectedVehicle == " Car3" ? Colors.blue : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(25.0),
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/driver_car.png",scale: 4,),

                                    SizedBox(height: 10,),

                                    Text(" Car3",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: selectedVehicle == " Car3" ? Colors.red :Colors.black,
                                        fontSize: 25,
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    Text("৳ 90",
                                      style: TextStyle(
                                        color: Colors.red.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),*/
                        ],
                      ),
                      SizedBox(height: 40,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children:[
                            GestureDetector(
                            onTap: (){
                              if(selectedVehicle!= ""){
                                saveRideRequestInformation(selectedVehicle);

                              }else
                                {
                                  Fluttertoast.showToast(msg: "Please select a vehicle from \n suggested rides");
                                }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.blueAccent, // Change the color as needed
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7, 0.7),
                                  )
                                ],
                              ),

                              child: Padding(
                                padding:  EdgeInsets.all(6.0), // Increase padding here
                                child: Text(
                                  'Request a Ride',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0, // Increase font size here
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ],
                      ),

                    ],
                  ),
                ),
              ),
            ),

            Positioned(
               bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height:searchForDriverContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24,vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LinearProgressIndicator(
                        color: Colors.blue,
                      ),
                      SizedBox(height: 10,),
                      Center(
                        child: Text(
                          "Searching For a driver.....",
                          style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),

                      GestureDetector(
                        onTap: (){
                          referenceRideRequest!.remove();
                          setState(() {
                             suggestedRidesContainerHeight = 0;
                             searchForDriverContainerHeight=0;
                          });
                        },
                        child: Container(
                          height: 51,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border:Border.all(width: 1,color: Colors.grey),
                          ),
                          child: Icon(Icons.close_sharp,size: 25,color: Colors.red,),
                        ),
                      ),
                      SizedBox(height: 15,),

                      Container(
                        width: double.infinity,
                        child: Text(
                          "Cancel",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            ///drawer button
            Positioned(
              top: 42,
              left: 19,
              child: GestureDetector(
                onTap: ()
                {
                  skey.currentState!.openDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const
                        [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          )
                    ]
                  ),
                  child:const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Icon(
                      Icons.menu_sharp,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }

}
