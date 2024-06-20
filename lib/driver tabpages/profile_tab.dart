import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frist_project/driver%20model/driver_data.dart';
import 'package:frist_project/driver%20tabpages/Driver_history.dart';
import '../aftersplash_second_page.dart';
import '../global/global_variable.dart';
import 'Driver_about.dart';
import 'driver_profile.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {


  DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("drivers");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.black,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 25),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${onlineDriverData.name}",
                          style:  TextStyle(
                            fontSize:17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white54,

                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            buildListTile(
              icon: Icons.person,
              title: "Visit Profile",
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (c) => DriverProfile()));
              },
            ),
            buildListTile(
              icon: Icons.history,
              title: "History",
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (c) => DriverHistory()));
              },
            ),
            buildListTile(
              icon: Icons.info,
              title: "About",
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (c) => DriverAbout()));
              },
            ),
            buildListTile(
              icon: Icons.logout,
              title: "Logout",
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (c) => SecondPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
      ),
    );
  }
}
