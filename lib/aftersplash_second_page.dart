import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:frist_project/authentication/login_screen.dart';
import 'package:frist_project/driver%20authentication/driver_login_screen.dart';

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white70,
        padding: EdgeInsets.all(35.0),
        child: Stack(
          alignment: Alignment.topCenter, // Align items to the top center of the stack
          children: [
            buildAnimatedText("You are welcome to choose the mode that suits you best"), // Animated text at the top
            SizedBox(height: 40.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildHoverButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (C) => LoginScreen()));
                  },
                  label: 'Login as User',
                ),
                SizedBox(height: 40.0),
                buildHoverButton(
                  onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (C)=> DriverLoginScreen()));
                  },
                  label: 'Login as Driver',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHoverButton({required VoidCallback onPressed, required String label}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueGrey.shade900,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Adjust button size
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildAnimatedText(String text) {
    return Positioned(
      top: 50.0, // Adjust the top position as needed
      child: AnimatedTextKit(
        animatedTexts: [
          TyperAnimatedText(
            text,
            textStyle: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
