import 'package:firebase_database/firebase_database.dart';

class DriverData {

  String? id;
  String? name;
  String? phone;
  String? email;
  String? address;
  String? car_color;
  String? car_model;
  String? car_number;
  String? car_type;


  DriverData({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.address,
    this.car_color,
    this.car_model,
    this.car_number,
    this.car_type,



  });

  DriverData.fromSnapshot(DataSnapshot snap){


    name = (snap.value as dynamic)["name"];
    id = snap.key;



  }

}