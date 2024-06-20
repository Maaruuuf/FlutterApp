import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frist_project/Assistants/request_assistant.dart';
import 'package:frist_project/models/predicted_places.dart';
import 'package:frist_project/pages/homepage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../global/global_variable.dart';
import '../widgets/place_prediction_tile.dart';



class SearchDestinationPage extends StatefulWidget {
  const SearchDestinationPage({super.key});

  @override
  State<SearchDestinationPage> createState() => _SearchDestinationPageState();
}

class _SearchDestinationPageState extends State<SearchDestinationPage> {


  TextEditingController destinationTextEditingController = TextEditingController();
  var uuid = Uuid();
  String _sessionToken = '123456';
  List<dynamic>_placesList = [];

   List<PredictedPlaces>placePredictedList = [];
  findPlaceAutoCompleteSearch(String inputText) async
  {
    if(inputText.length > 1 ){
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$googleMapKey&components=country:BD";

      var responseAutoCompleteSearch = await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

      if(responseAutoCompleteSearch == "Error Occured. Failed. No Response"){
        return;
      }
      if(responseAutoCompleteSearch["status"] == "ok"){
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionList = (placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

        setState(() {
          placePredictedList = placePredictionList;
        });

      }



    }

  }


/* @override
  void initState() {
    // TODO: implement initState
    super.initState();
    destinationTextEditingController.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (_sessionToken == null) {
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(destinationTextEditingController.text);
  }

  void getSuggestion(String input) async
  {
    String kPLACES_API_KEY = "AIzaSyBSGMNTVZwqcGsOxSB5aJDsKzrTxSUXqQ0";
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = response.body.toString();

    if (response.statusCode == 200) {
      setState(() {
        _placesList = jsonDecode(response.body.toString()) ['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }*/


  /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [

            Card(
              elevation: 15,
              child: Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Colors.black12,
                  boxShadow:
                  [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),

                    ),

                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24,top: 48,right: 24,bottom: 20),
                  child: Column(
                    children: [

                      const SizedBox(height: 6,),

                      //icon button
                      Stack(
                        children: [
                          GestureDetector(
                              onTap:(){
                                Navigator.push(context,MaterialPageRoute(builder:(C)=> HomePage()));
                              },

                              child: Icon(Icons.arrow_back,color: Colors.white,),

                          ),
                          const Center(
                            child: Text(
                              "Set Destination Location",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                        ],

                      ),

                      const SizedBox(height: 15,),

                      Row(
                        children: [

                          Image.asset(
                            "assets/images/destination.png",
                            height: 25,
                            width: 25,

                          ),

                          const SizedBox(width: 18,),

                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(

                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  controller: destinationTextEditingController,
                                  decoration:const InputDecoration(
                                      hintText: "Search Destination Address",
                                      fillColor: Colors.white12,
                                      filled: true,
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(left: 11,top: 9,bottom: 9)


                                  ),

                                ),


                              ),
                            ),
                          ),
                          /*Expanded(
                            child:ListView.builder(
                              itemCount: _placesList.length,
                              itemBuilder: (context,index){
                                return ListTile(
                                  title: Text(_placesList[index]['description']),
                                );
                              },
                            ),
                          ),*/

                        ],
                      ),

                    ],
                  ),

                ),
              ),
            ),
          ],
        ),
      ),


    );
  }

}*/

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child:Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap:(){
              Navigator.pop(context);
            },
           child: Icon(Icons.arrow_back,color: Colors.black,),
          ),
          title: Text(
            "Search and Set Destination place",
            style: TextStyle(color: Colors.black87),
          ),
          elevation: 0.0,
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[200],
                boxShadow: [
                  BoxShadow(
                    color: Colors.black87,
                    blurRadius: 15,
                    spreadRadius: 8,
                    offset: Offset(0.7,0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 30,
                          color: Colors.green[700],
                        ),
                        SizedBox(height: 18.0,),

                        Expanded(
                            child: Padding(
                             padding: EdgeInsets.all(8),
                             child: TextField(
                               onChanged: (value){
                                 findPlaceAutoCompleteSearch(value);
                               },
                            decoration: InputDecoration(
                              hintText: "Search Location",
                              fillColor: Colors.blueGrey,
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                left: 11,
                                top: 8,
                                bottom: 8,
                              ),
                            ),
                          ),
                         ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            //display place prediction list
            (placePredictedList.length > 0)
            ?Expanded(
              child: ListView.separated(
                  itemCount: placePredictedList.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context,index){
                    return PlacePredictionTileDesign(
                      predictedPlaces: placePredictedList[index],
                    );
                  },
                separatorBuilder: (BuildContext context,int index){
                    return Divider(
                        height: 0,
                        color: Colors.white54,
                      thickness: 0,
                    );
                },
              ),
            ): Container(


            ),

          ],
        ),
      ) ,
    );
  }



}

