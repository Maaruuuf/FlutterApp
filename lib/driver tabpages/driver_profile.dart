import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../global/global_variable.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {

  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("drivers");


  Future<void> showUserNameDialogAlert(BuildContext context, String name) {
    nameTextEditingController.text = name;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update"),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                TextFormField(
                  controller: nameTextEditingController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                usersRef.child(firebaseAuth.currentUser!.uid).update({
                  "name": nameTextEditingController.text.trim(),
                }).then((value) {
                  nameTextEditingController.clear();
                  Fluttertoast.showToast(msg: "Updated Successfully.");
                }).catchError((errorMessage) {
                  Fluttertoast.showToast(msg: "Error occurred");
                });

                Navigator.pop(context);
              },
              child: Text(
                "Ok",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }


  Future<void> showPhoneDialogAlert(BuildContext context, String phone) {

    phoneTextEditingController.text = phone;


    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneTextEditingController,
                  ) // TextFormField
                ],
              ), // Column
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: () {
                  usersRef.child(firebaseAuth.currentUser!.uid).update({
                    "phone": phoneTextEditingController.text.trim(),
                  }).then((value){
                    phoneTextEditingController.clear();
                    Fluttertoast.showToast(msg: "Updated Successfully.");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(msg: "Error occured");
                  });

                  Navigator.pop(context);
                },
                child: Text("Ok", style: TextStyle(color: Colors.black),),
              ),
            ],
          );
        }
    );
  }

  Future<void> showAddressDialogAlert(BuildContext context, String address) {


    addressTextEditingController.text = address;


    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: addressTextEditingController,
                  ) // TextFormField
                ],
              ), // Column
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red),),
              ),
              TextButton(
                onPressed: () {
                  usersRef.child(firebaseAuth.currentUser!.uid).update({
                    "address": addressTextEditingController.text.trim(),
                  }).then((value){
                    phoneTextEditingController.clear();
                    Fluttertoast.showToast(msg: "Updated Successfully.");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(msg: "Error occured");
                  });

                  Navigator.pop(context);
                },
                child: Text("Ok", style: TextStyle(color: Colors.black),),
              ),
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context){

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: Text("Profile Screen",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.person,color: Colors.white,size: 60,),
                ),
                SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${onlineDriverData.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        showUserNameDialogAlert(context, "${onlineDriverData.name}");
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                Divider(
                  thickness: 3,
                  color: Colors.blueGrey,
                ),

                  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${onlineDriverData.phone}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.black
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        showPhoneDialogAlert(context, "${onlineDriverData.phone}");
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                Divider(
                  thickness: 3,
                  color: Colors.blueGrey,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${onlineDriverData.address}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.black
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        showAddressDialogAlert(context, "${onlineDriverData.address}");
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                Divider(
                  thickness: 3,
                  color: Colors.blueGrey,
                ),

                SizedBox(height: 2,),
               /* Text(
                  "${onlineDriverData.email}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }













}
