import 'package:flutter/material.dart';

class DriverLoadingDialogue extends StatelessWidget {
  String messageText;

  DriverLoadingDialogue({super.key,required this.messageText,});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(9),
      ),
      backgroundColor: Colors.black87,
      child: Container(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(9),
          child: Row(
            children: [
              const SizedBox(width: 5,),
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(width: 8,),
              Text(
                messageText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

