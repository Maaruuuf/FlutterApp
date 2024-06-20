import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/authentication/signup_screen.dart';
import 'package:frist_project/pages/homepage.dart';
import '../global/global_variable.dart';
import '../methods/common_methods.dart';
import '../widgets/loading_dialogue.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {


  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();
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
      builder: (BuildContext context) => LoadingDialog(messageText: "Login Successful...."),
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
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
      usersRef.once().then((snap)
      {
        if(snap.snapshot.value != null)
        {
          if((snap.snapshot.value as Map)["blockStatus"]=="no")
          {
            userName = (snap.snapshot.value as Map)["name"];
            Navigator.push(context,MaterialPageRoute(builder: (c) => HomePage()));
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
          cMethods.displaySnackBar("your record do not exist as a user ", context);

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
               Text(
                " Login as a User ",
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
                      decoration:  InputDecoration(
                          labelText: "Email address",
                          labelStyle: TextStyle(
                            fontSize: 15,
                          ),
                        filled: true,
                        fillColor: Colors.blueGrey.shade300,
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

                  Navigator.push(context, MaterialPageRoute(builder: (C)=>SignUpScreen()));

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
