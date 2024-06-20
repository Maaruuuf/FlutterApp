import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CallingDriverDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated text
            TyperAnimatedTextKit(
              onTap: () {
                print("Text Tapped");
              },
              text: ["Calling the Driver"],
              textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20.0),
            // Custom phone calling style design

            SizedBox(height: 20.0),
            // Cancel call button
            GestureDetector(
              onTap: () {

                print("Cancel Call");
                Navigator.pop(context); // Close the dialog
              },
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
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
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CallingDriverDialog();
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
