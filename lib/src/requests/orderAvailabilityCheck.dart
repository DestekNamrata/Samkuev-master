import 'dart:convert';

import 'package:fluttertoast/fluttertoast.dart';

import '/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> orderAvailabilityCheck(Map<String, dynamic> body) async {
  String url = "$GLOBAL_URL/order/availability";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final client = new http.Client();

  // Map<String, String> body = {};

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  Map<String, dynamic> responseJson = {};
  print(response.body);

  try {
    if (response.statusCode == 200) {
      responseJson = json.decode(response.body) as Map<String, dynamic>;
    }else if(response.statusCode == 500){
      Fluttertoast.showToast(msg: "Internal Server error");
    }
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
