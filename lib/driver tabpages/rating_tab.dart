import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class DriverRatingPage extends StatefulWidget {
  @override
  _DriverRatingPageState createState() => _DriverRatingPageState();
}

class _DriverRatingPageState extends State<DriverRatingPage> {
  double communicationRating = 0.0;
  double punctualityRating = 0.0;
  double drivingSkillsRating = 0.0;

  String positiveReview = 'Great driver! Very polite and punctual. Highly recommend.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Driver Rating',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 60),
              buildRatingAttribute('Communication', communicationRating, (rating) {
                setState(() {
                  communicationRating = rating;
                });
              }),
              buildRatingAttribute('Punctuality', punctualityRating, (rating) {
                setState(() {
                  punctualityRating = rating;
                });
              }),
              buildRatingAttribute('Driving Skills', drivingSkillsRating, (rating) {
                setState(() {
                  drivingSkillsRating = rating;
                });
              }),
              Divider(
                color: Colors.white,
                height: 40,
              ),
              Text(
                'Customer Reviews',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 40),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      positiveReview,
                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Additional text in the review box. More positive comments.',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              buildReviewBox('Review 1', 'Positive comment. Would recommend.'),
              SizedBox(height: 16),
              buildReviewBox('Review 2', 'Excellent service. Punctual and professional.'),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRatingAttribute(String attribute, double rating, ValueChanged<double> onRatingChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          attribute,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        SizedBox(height: 8),
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 40,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber, // Set the color to yellow by default
          ),
          onRatingUpdate: onRatingChanged,
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget buildReviewBox(String title, String review) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(height: 8),
          Text(
            review,
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
