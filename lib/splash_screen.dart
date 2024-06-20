import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/authentication/login_screen.dart';
import 'package:frist_project/pages/homepage.dart';

import 'aftersplash_second_page.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  starTimer()
  {
    Timer(const Duration(seconds: 5), () async
    {
      Navigator.push(context, MaterialPageRoute(builder: (C)=> SecondPage()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/ab1.png",
            scale: 1.4,
            ),

            const  SizedBox(height: 40,),

             Container(
               alignment: Alignment.center,
                 child: Text(
                  "GET A RIDE",
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
               ),



          ],
        ),
      ),

    );
  }
}
