import 'package:flutter/material.dart';
import 'package:frist_project/driver%20mainscreen/driver_mainscreen.dart';
import 'package:frist_project/driver%20tabpages/home_tab.dart';

class DriverEarningPage extends StatefulWidget {
  double? earningAmount;

  DriverEarningPage({this.earningAmount});

  @override
  State<DriverEarningPage> createState() => _DriverEarningPageState();
}

class _DriverEarningPageState extends State<DriverEarningPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null, // Remove the AppBar
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              "Earning Details",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 45,
              ),
            ),
            SizedBox(height: 80),
            Text(
              "Total Earnings ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 40,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "৳" + widget.earningAmount.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 60),
            Text(
              "This is your total earnings. You can view your overall income here.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.limeAccent,
              ),
              onPressed: () {
                // Handle any additional actions when the button is pressed
                Navigator.push(context,MaterialPageRoute(builder: (c) =>MainScreen()));
              },
              child: Text(
                "Close",
                style: TextStyle(
                  fontSize: 16,
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
