import 'package:flutter/material.dart';
import 'package:frist_project/Assistants/request_assistant.dart';
import 'package:frist_project/global/global_variable.dart';
import 'package:frist_project/info_handler/app_info.dart';
import 'package:frist_project/models/directions.dart';
import 'package:provider/provider.dart';

import '../models/predicted_places.dart';
import 'loading_dialogue.dart';

class PlacePredictionTileDesign extends StatefulWidget {


  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({this.predictedPlaces});


  @override
  State<PlacePredictionTileDesign> createState() => _PlacePredictionTileDesignState();
}

class _PlacePredictionTileDesignState extends State<PlacePredictionTileDesign> {


  getPlaceDirectionDetails(String? placeId,context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => LoadingDialog(
        messageText: "setting up drop off... please wait",
      )
    );

    String placePredictionDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleMapKey";
    var responseApi = await RequestAssistant.receiveRequest(placePredictionDetailsUrl);

    Navigator.pop(context);

    if(responseApi == "Error Occured. Failed. No Response"){
      return;
    }

    if(responseApi["status"] == "ok"){
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi["result"]["geometry"]["location"]["lat"];
      directions.locationLongitude =responseApi["result"]["geometry"]["location"]["lng"];

      Provider.of<AppInfo>(context,listen: false).updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });

      Navigator.pop(context,"obtainDropOff");

    }




  }


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (){
        getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              Icons.add_location,
              color: Colors.white54,
            ),
            SizedBox(width: 10,),

            Expanded(
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        widget.predictedPlaces!.main_text!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),

                    Text(
                      widget.predictedPlaces!.secondary_text!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),

                  ],
                ),
            ),
          ],
        ),

      ),
    );
  }
}
