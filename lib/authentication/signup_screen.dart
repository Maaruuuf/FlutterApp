import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/authentication/login_screen.dart';
import 'package:frist_project/pages/homepage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../methods/common_methods.dart';
import '../widgets/loading_dialogue.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController userNameTextEditingController = TextEditingController();
  TextEditingController userPhoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
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
      builder: (BuildContext context) => LoadingDialog(messageText: "Registering your account.... "),
    );

    final User? userFirebase = (
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailTextEditingController.text.trim(),
          password: passwordTextEditingController.text.trim(),
        ).catchError((errorMsg)
        {
          cMethods.displaySnackBar(errorMsg.toString(), context);

          Navigator.push(context,MaterialPageRoute(builder: (c) => SignUpScreen()));

        })
    ).user;

    if(!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);

    Map userDataMap =
    {
      "name": userNameTextEditingController.text.trim(),
      "email":emailTextEditingController.text.trim(),
      "phone":userPhoneTextEditingController.text.trim(),
      "id":userFirebase.uid,
      "blockStatus":"no",
    };

    usersRef.set(userDataMap);

    Navigator.push(context,MaterialPageRoute(builder: (c) => HomePage()));
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
                  "assets/images/face1.png",
                scale: 1.6,
              ),
              SizedBox(height: 7,),
               Text(
                "Create a user\'s Account ",
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

                  Navigator.push(context, MaterialPageRoute(builder: (C)=> LoginScreen()));

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



