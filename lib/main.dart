import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/aftersplash_second_page.dart';
import 'package:frist_project/driver%20tabpages/earning_tab.dart';
import 'package:frist_project/info_handler/app_info.dart';
import 'package:frist_project/pages/accepted_request_dialog.dart';
import 'package:frist_project/pages/visit_profile.dart';
import 'package:frist_project/raing_page_for_user.dart';
import 'package:frist_project/splash_screen.dart';
import 'package:frist_project/widgets/another_dialogue_box.dart';
import 'package:frist_project/widgets/pay_fare_amount_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'driver authentication/driver_login_screen.dart';
import 'driver tabpages/driver_profile.dart';
import 'driver tabpages/rating_tab.dart';




void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(

    options: FirebaseOptions(
      apiKey: "AIzaSyBSGMNTVZwqcGsOxSB5aJDsKzrTxSUXqQ0",
      appId: "1:729484814578:android:47b587a778d9782c83c86b",
      messagingSenderId: "729484814578" ,
      projectId: "project22-c24bc",
    ),
  );

  await Permission.locationWhenInUse.isDenied.then((valueOfPermission)
      {
        if(valueOfPermission)
          {
            Permission.locationWhenInUse.request();
          }
      }
  );

  runApp(const MyApp());


}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'GET A RIDE ',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.white,
        ),
       home:
       const MySplashScreen(),

      ),
    );
  }
}





