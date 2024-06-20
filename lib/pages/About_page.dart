import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get A Ride'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,

                ),
              ),
              SizedBox(height: 20),
              Text(
                'Welcome to RideShare, your go-to app for convenient and reliable transportation!',
                style: TextStyle(fontSize: 16,
                color: Colors.black,),
              ),
              SizedBox(height: 20),
              Text(
                'Key Features:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text('- Request a ride anytime, anywhere.',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),
              Text('- Choose from a variety of vehicles.',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),
              Text('- Track your ride in real-time.',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),
              Text('- Safe and professional drivers.',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),
              SizedBox(height: 20),
              Text(
                'Contact Us:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Text('Email: support@rideshareapp.com',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),
              Text('Phone: 0123-456-7890',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),
            ],
          ),
        ),
      ),
    );
  }
}

