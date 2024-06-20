import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/driver%20authentication/driver_signup_screen.dart';
import 'package:frist_project/driver%20mainscreen/driver_mainscreen.dart';
import 'package:frist_project/driver%20methods/driver_common_methods.dart';
import 'package:frist_project/driver%20widget/driver_loading_dialogue.dart';

import '../aftersplash_second_page.dart';
import '../global/global_variable.dart';


class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({super.key});

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {


  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  DriverCommonMethods cMethods = DriverCommonMethods();
  bool passwordVisible=false;

  @override
  void initState(){
    super.initState();
    passwordVisible=true;
  }

  checkIfNetworkIsAvailable()
  {
    cMethods.checkConnectivity(context);
    signUpFormValidation();
  }

  signUpFormValidation()
  {if(!emailTextEditingController.text.contains("@"))
  {
    cMethods.displaySnackBar("Please write valid email ", context);
  }
  else if(passwordTextEditingController.text.trim().length < 5)
  {
    cMethods.displaySnackBar(" Your password must be atleast 6 or more characters ", context);
  }
  else
  {
    signInUser();
  }
  }

  signInUser() async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => DriverLoadingDialogue(messageText: "Login Successful...."),
    );

    final User? userFirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((errorMsg)
        {
          Navigator.pop(context);
          cMethods.displaySnackBar(errorMsg.toString(), context);
        })
    ).user;

    if(!context.mounted) return;
    Navigator.pop(context);

    if(userFirebase != null)
    {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("drivers").child(userFirebase.uid);
      usersRef.once().then((snap)
      {
        if(snap.snapshot.value != null)
        {
          if((snap.snapshot.value as Map)["blockStatus"]=="no")
          {
            userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(context,MaterialPageRoute(builder: (c) => MainScreen()));
          }
          else
          {
            FirebaseAuth.instance.signOut();
            cMethods.displaySnackBar("you are blocked", context);
          }

        }
        else
        {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar("your record do not exist as a driver ", context);

        }
      });
    }
  }











  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Image.asset(
                  "assets/images/tr1.png",
                scale: 1.6,
              ),
              SizedBox(height: 25,),
              const Text(
                " Login as a Driver ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 35,),


              //text field + button done
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [

                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email address",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade300, // Set the background color to black
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 22,),

                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: passwordVisible,
                      keyboardType: TextInputType.text,
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                                  () {
                                passwordVisible = !passwordVisible;
                              },
                            );
                          },
                        ),
                        alignLabelWithHint: false,
                        filled: true,
                        fillColor: Colors.blueGrey.shade300,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 32,),

                    ElevatedButton(
                      onPressed: ()
                      {
                        checkIfNetworkIsAvailable();
                      },
                      style: ElevatedButton.styleFrom(

                          backgroundColor: Colors.grey.shade900,
                          padding: const EdgeInsets.symmetric(horizontal: 85, vertical: 19)
                      ),
                      child: const Text(
                          "Login"
                      ),
                    ),


                  ],
                ),

              ),

              const SizedBox(height: 15,),

              //textbutton + new page button
              TextButton(
                onPressed:(){

                  Navigator.push(context, MaterialPageRoute(builder: (C)=>DriverSignUpScreen()));

                },
                child: const Text(
                  "Don\'t have an Account? SignUp Here ",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),




            ],
          ),
        ),
      ),

    );
  }






}
