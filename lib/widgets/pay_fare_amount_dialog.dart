import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'another_dialogue_box.dart';

class PayFareAmountDialog extends StatefulWidget {
  double? fareAmount;

  PayFareAmountDialog({this.fareAmount});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}

class _PayFareAmountDialogState extends State<PayFareAmountDialog> {
  bool isCashOnHandSelected = true;
  String selectedDigitalPayment = "bKash"; // Default option

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(30),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Fare Amount".toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: isCashOnHandSelected
                        ? Colors.limeAccent
                        : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      isCashOnHandSelected = true;
                    });
                  },
                  child: Text(
                    "Cash on Hand",
                    style: TextStyle(
                      fontSize: 17,
                      color: isCashOnHandSelected
                          ? Colors.black
                          : Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: !isCashOnHandSelected
                        ? Colors.limeAccent
                        : Colors.white,
                  ),
                  onPressed: () {
                    _showDigitalPaymentDialog();
                    setState(() {

                      isCashOnHandSelected = false;
                    });
                  },
                  child: Text(
                    selectedDigitalPayment,
                    style: TextStyle(
                      fontSize: 17,
                      color: !isCashOnHandSelected
                          ? Colors.black
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Divider(
              thickness: 2,
              color: Colors.white54,
            ),
            SizedBox(height: 10),
            Text(
              "৳" + widget.fareAmount.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white54,
                fontSize: 50,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "This is the total trip fare amount. Please pay it to the driver",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.limeAccent,
                ),
                onPressed: () {
                  if (isCashOnHandSelected) {
                   // Fluttertoast.showToast(msg: "Thank you. Driver will collect the payment soon");
                    Navigator.push(context,MaterialPageRoute(builder: (context) => AnotherDialogue()));
                  } else if(isCashOnHandSelected==false) {
                    //Fluttertoast.showToast(msg: "Digital Payment: Successfully paid through $selectedDigitalPayment ",);
                    Navigator.push(context,MaterialPageRoute(builder: (context) => AnotherDialogue()));
                  }
                },
                child: Row(
                  children: [
                    Text(
                      isCashOnHandSelected ? "Pay Cash on Hand" : "Pay Digital",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "৳" + widget.fareAmount.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white54,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  // Function to show the digital payment dialog
  void _showDigitalPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 10),
                    Text(
                      "Digital Payment Options",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/bkash2.png",
                      scale: 30,
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDigitalPayment = "Bkash";
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Bkash"),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/nogod.png",
                      scale: 14,
                    ),
                    SizedBox(width: 25),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          selectedDigitalPayment = "Nogod";
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Nogod"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}
