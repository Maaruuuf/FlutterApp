import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/driver%20authentication/driver_login_screen.dart';
import 'package:frist_project/driver%20methods/driver_common_methods.dart';
import 'package:frist_project/driver%20widget/driver_loading_dialogue.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../driver mainscreen/driver_mainscreen.dart';

class DriverSignUpScreen extends StatefulWidget {
  const DriverSignUpScreen({super.key});

  @override
  State<DriverSignUpScreen> createState() => _DriverSignUpScreenState();
}

class _DriverSignUpScreenState extends State<DriverSignUpScreen> {

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userPhoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController nidNumberTextEditingController = TextEditingController();
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController = TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();
  DriverCommonMethods cMethods = DriverCommonMethods();
  String fullPhone = '';

  checkIfNetworkIsAvailable()
  {
    cMethods.checkConnectivity(context);
    signUpFormValidation();
  }
  signUpFormValidation()
  {
    if(userNameTextEditingController.text.trim().length < 3)
    {
      cMethods.displaySnackBar("Your name must be 4 or more characters", context);
    }
    else if(userPhoneTextEditingController.text.trim().length < 9)
    {
      cMethods.displaySnackBar("Please give appropriate number ", context);
    }
    else if(!emailTextEditingController.text.contains("@"))
    {
      cMethods.displaySnackBar("Please write valid email ", context);
    }
    else if(passwordTextEditingController.text.trim().length < 5)
    {
      cMethods.displaySnackBar(" Your password must be atleast 6 or more characters ", context);
    }
    else if(addressTextEditingController.text.trim().isEmpty)
    {
      cMethods.displaySnackBar(" Please give valid address ", context);
    }
    else if(nidNumberTextEditingController.text.trim().isEmpty)
    {
      cMethods.displaySnackBar(" Please give valid NID Number ", context);
    }
    else if(carModelTextEditingController.text.trim().isEmpty)
    {
      cMethods.displaySnackBar(" Please give valid Car Model ", context);
    }
    else if(carNumberTextEditingController.text.trim().isEmpty)
    {
      cMethods.displaySnackBar("  Please give valid Car Number ", context);
    }
    else if(carColorTextEditingController.text.trim().isEmpty)
    {
      cMethods.displaySnackBar("  Please give valid Car Color ", context);
    }
    else
    {
      registerNewUser();

    }
  }


  registerNewUser()async
  {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => DriverLoadingDialogue(messageText: "Registering your account.... "),
    );

    final User? userFirebase = (
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((errorMsg)
        {
          cMethods.displaySnackBar(errorMsg.toString(), context);
          Navigator.push(context,MaterialPageRoute(builder: (c) => DriverSignUpScreen()));
        })
    ).user;

    if(!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("drivers").child(userFirebase!.uid);

    Map driverCarInfo =
    {
      "carColor":carColorTextEditingController.text.trim(),
      "carModel":carModelTextEditingController.text.trim(),
      "carNumber":carNumberTextEditingController.text.trim(),
    };

    Map userDataMap =
    {
      "car_details":driverCarInfo,
      "name": userNameTextEditingController.text.trim(),
      "email":emailTextEditingController.text.trim(),
      "phone":userPhoneTextEditingController.text.trim(),
      "address":addressTextEditingController.text.trim(),
      "nidNumber":nidNumberTextEditingController.text.trim(),
      "id":userFirebase.uid,
      "blockStatus":"no",
    };

    usersRef.set(userDataMap);

    Navigator.push(context,MaterialPageRoute(builder: (c) => MainScreen()));
  }


  bool passwordVisible=false;
  @override
  void initState(){
    super.initState();
    passwordVisible=true;
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
                  "assets/images/man1.png",scale: 1.5,
              ),
               SizedBox(height: 7,),
               Text(
                "Create a Driver\'s Account ",
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
                      controller: userNameTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "username",
                          helperText:"Name must be 4 or more characters",
                          helperStyle:TextStyle(color:Colors.green),
                          labelText: "User Name",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade300,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18,),

                    TextField(
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "email",
                          helperText:"Please write valid email",
                          helperStyle:TextStyle(color:Colors.green),
                          labelText: "Email address",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade300,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18,),

                    IntlPhoneField(
                        showCountryFlag: true,
                        controller: userPhoneTextEditingController,
                        keyboardType: TextInputType.phone,
                        decoration:  InputDecoration(
                            border: UnderlineInputBorder(),
                            helperText:"Please give appropriate number",
                            helperStyle:TextStyle(color:Colors.green),
                            labelText: "Phone Number",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          filled: true,
                          fillColor: Colors.blueGrey.shade300,
                        ),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        initialCountryCode: 'BD',
                        onChanged: (phone) {
                          print(phone.completeNumber);
                          setState(() {
                            fullPhone = phone.completeNumber;
                          });
                        }),
                    const SizedBox(height: 18,),

                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: passwordVisible,
                      keyboardType: TextInputType.text,
                      decoration:  InputDecoration(
                        border: UnderlineInputBorder(),
                        hintText: "Password",
                        labelText: "Password",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        helperText:"Password must be atleast 6 or more characters",
                        helperStyle:TextStyle(color:Colors.green),
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
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18,),

                    TextField(
                      controller: addressTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Your address",
                          helperText:"Please give valid one",
                          helperStyle:TextStyle(color:Colors.green),
                          labelText: "Address",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade300,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18,),

                    TextField(
                      controller: nidNumberTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Your NID no",
                          helperText:"Please give valid one",
                          helperStyle:TextStyle(color:Colors.green),
                          labelText: "NID No",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade300,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18,),

                    TextField(
                      controller: carModelTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Your car model",
                          helperText:"Please give valid one",
                          helperStyle:TextStyle(color:Colors.green),
                          labelText: "Car Model",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade300,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18,),

                    TextField(
                      controller: carNumberTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "Your car number",
                          helperText:"Please give valid one",
                          helperStyle:TextStyle(color:Colors.green),
                          labelText: "Car Number",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade300,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 18,),

                    TextField(
                      controller: carColorTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:  InputDecoration(
                          border: UnderlineInputBorder(),
                          hintText: "your car color",
                          helperText:"Please give valid one",
                          helperStyle:TextStyle(color:Colors.green),
                          labelText: "Car color",
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade300,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 22,),


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
                          "Sign Up"
                      ),
                    ),


                  ],
                ),

              ),

              const SizedBox(height: 5,),

              //textbutton + new page button
              TextButton(
                onPressed:(){

                  Navigator.push(context, MaterialPageRoute(builder: (C)=> DriverLoginScreen()));

                },
                child: const Text(
                  "Already have an Account? Login Here",
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
