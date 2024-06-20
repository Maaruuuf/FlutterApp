import 'package:firebase_database/firebase_database.dart';

class UserModel {
  String? phone;
  String? name;
  String? id;
  String? email;
  String? address;

  UserModel({
    this.name,
    this.phone,
    this.id,
    this.email,
    this.address,

});

  UserModel.fromSnapshot(DataSnapshot snap){


    name = (snap.value as dynamic)["name"];
    id = snap.key;



  }


}