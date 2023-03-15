import 'dart:convert';

import '/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> manufactureRequest(String apiUrl) async {
  String url = "$GLOBAL_URL"+apiUrl;

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
