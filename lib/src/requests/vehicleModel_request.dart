import 'dart:convert';

import '/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> vehicleModelRequest(String manuId,String vehicleTypeId) async {
  String url = "$GLOBAL_URL/get_models_by_oem_and_vehicle_type?oem_id="+manuId+"&vehicle_type_id="+vehicleTypeId;

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final client = new http.Client();



  final response = await client.get(Uri.parse(url),
      headers: headers);

  Map<String, dynamic> responseJson = {};


  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;

  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
