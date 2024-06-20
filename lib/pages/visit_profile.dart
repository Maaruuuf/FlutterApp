import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frist_project/global/global_variable.dart';

class Visitprofile extends StatefulWidget {
  const Visitprofile({super.key});

  @override
  State<Visitprofile> createState() => _VisitprofileState();
}

class _VisitprofileState extends State<Visitprofile> {

  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users");


  Future<void> showUserNameDialogAlert(BuildContext context, String name) {

    userName = userModelCurrentInfo!.name!;
    /*userPhone = userModelCurrentInfo!.phone!;
    userEmail = userModelCurrentInfo!.email!;*/

    nameTextEditingController.text = name;


    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameTextEditingController,
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
                    "name": nameTextEditingController.text.trim(),
                  }).then((value){
                    nameTextEditingController.clear();
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
                      userName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        showUserNameDialogAlert(context, userName);
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                Divider(
                  thickness: 2,
                  color: Colors.blueGrey,
                ),

              /*  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${userModelCurrentInfo.phone}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        showUserNameDialogAlert(context, "${userModelCurrentInfo.phone}");
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),

                Divider(
                  thickness: 1,
                  color: Colors.black,
                ),

                Text(
                  "${userModelCurrentInfo.email}",
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