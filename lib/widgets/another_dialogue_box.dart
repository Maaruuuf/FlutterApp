import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../raing_page_for_user.dart';

class AnotherDialogue extends StatefulWidget {
  const AnotherDialogue({super.key});

  @override
  State<AnotherDialogue> createState() => _AnotherDialogueState();
}

class _AnotherDialogueState extends State<AnotherDialogue> {
  @override
  Widget build(BuildContext context) {
        return AlertDialog(

          title: Text(
            'Confirmation',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to proceed?',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context) => RatingPage()));
                Fluttertoast.showToast(msg: "Thank you. Driver will collect the payment soon");
              },
              child: Text(
                'Confirm',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () {

                Navigator.pop(context);
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      }
}

