

import 'package:flutter/cupertino.dart';
import 'package:frist_project/models/directions.dart';

class AppInfo extends ChangeNotifier{

  Directions? userPickUpLocation,userDropOffLocation;
  int countTotalTrips = 0;


  //List<String>historyTripKeyList = [];
  //List<TripHistoryModel> allTripHistoryInfo = [];


  void updatePickUpLocationAddress(Directions userPickUpAddress)
  {
    userPickUpLocation = userPickUpAddress;
    notifyListeners();
  }

  void updateDropOffLocationAddress(Directions dropOffAddress)
  {
    userDropOffLocation = dropOffAddress;
    notifyListeners();
  }


}