
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

import '../global/global_variable.dart';


class DriverAssistantMethods{

  static pauseLiveLocationUpdates(){
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(firebaseAuth.currentUser!.uid);
  }

}