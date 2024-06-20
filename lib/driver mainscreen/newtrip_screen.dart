import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../driver model/user_ride_request_information.dart';


class NewTripScreen extends StatefulWidget {


  UserRideRequestInformation? userRideRequestDetails;

  NewTripScreen({this.userRideRequestDetails,});


  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {




  GoogleMapController? controllerGoogleMap;
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();

  static const CameraPosition googlePlexInitialPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 25.4746,
  );






  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'this is trip screen',
      ),
    );
  }
}
