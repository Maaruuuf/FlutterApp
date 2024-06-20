import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:frist_project/pages/homepage.dart';

import '../widgets/pay_fare_amount_dialog.dart';
import 'call_driver.dart';

class AcceptedRequestDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Custom back button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
                },
              ),
            ),
            // Animated text
            TyperAnimatedTextKit(
              onTap: () {
                print("Text Tapped");
              },
              text: ["Your request has been accepted.", "Driver is on the way."],
              textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            // Fair Amount button
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => PayFareAmountDialog()));
                print("Fair Amount");
              },
              child: Text("Fair Amount"),
            ),
            SizedBox(height: 10.0),
            // Call button
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (c) => CallingDriverDialog()));
                print("Call the driver");
              },
              child: Text("Call the Driver"),
            ),
            SizedBox(height: 10.0),
            // Cancel button
            ElevatedButton(
              onPressed: () {
                // Handle cancel button press
                print("Cancel the driver");
                Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage())); // Close the dialog
              },
              child: Text("Cancel the Driver"),
            ),
          ],
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AcceptedRequestDialog();
                },
              );
            },
            child: Text('Show Dialog'),
          ),
        ),
      ),
    );
  }
}
