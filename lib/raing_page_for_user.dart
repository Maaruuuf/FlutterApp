import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frist_project/pages/homepage.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double _rating = 0.0;
  TextEditingController _ratingController = TextEditingController();

  void _showToast() {
    Fluttertoast.showToast(
      msg: 'Rating submitted successfully!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevents white space from showing at the bottom when the keyboard appears
      backgroundColor: Colors.black, // Set background color to black
      body: Container(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Driver Rating',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ratingController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: 'Enter Rating',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      double userInput = double.tryParse(_ratingController.text) ?? 0.0;
                      if (userInput >= 1 && userInput <= 5) {
                        setState(() {
                          _rating = userInput;
                        });
                        _showToast(); // Show FlutterToast
                        Future.delayed(Duration(milliseconds: 3000),(){
                          Navigator.push(context,MaterialPageRoute(builder: (c) =>HomePage()));
                        });
                      } else {
                        // Handle invalid input (outside the range 1-5)
                        Fluttertoast.showToast(
                          msg: 'Please enter a rating between 1 and 5.',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amberAccent, // Black stars initially
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Your Rating: $_rating',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'Rating Bar Indicator:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              RatingBarIndicator(
                rating: _rating,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amberAccent,
                ),
                itemCount: 5,
                itemSize: 50.0,
                direction: Axis.vertical,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
