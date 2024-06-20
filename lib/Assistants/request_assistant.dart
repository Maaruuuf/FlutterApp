import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestAssistant{

  static Future<dynamic>receiveRequest(String url) async {

    http.Response httpResponse = await http.get(Uri.parse(url));

    try{
      if(httpResponse.statusCode == 200)
        {
          String jSonData = httpResponse.body;
          var decodeData = jsonDecode(jSonData);
          return decodeData;
        }
      else
        {
          return "Error Occured. Failed. No Response. ";
        }

    }catch(exp){

      return "Error Occured. Failed. No Response. ";
    }



  }





}