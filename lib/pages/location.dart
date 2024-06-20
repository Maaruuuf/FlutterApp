
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class SelectLocationPage extends StatelessWidget {
  final List<LatLng> locations;
  final Function(LatLng?) onLocationSelected;

  SelectLocationPage({required this.locations, required this.onLocationSelected});


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Location ${index + 1}'),
            onTap: () {
              onLocationSelected(locations[index]);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
