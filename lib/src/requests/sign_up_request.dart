import 'dart:convert';
import 'dart:io';

import '/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> signUpRequest(
    String name,
    String surname,
    String bikeName,
    String bikenumber,
    String modelnumber,
    String email,
    String phone,
    String password,
    int authType,
    String socialId,
    String pushToken,
    String manufactId,
    String vehicleTypeId,
    String modelId) async {
  String url = "$GLOBAL_URL/client/signup";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  Map<String, String> body = {
    "name": name,
    "surname": surname,
    "bikename": bikeName,
    "bikenumber": bikenumber,
    "modelnumber": modelnumber,
    "email": email,
    "phone": phone,
    "password": password,
    "auth_type": authType.toString(),
    "social_id": socialId,
    "device_type": Platform.isAndroid ? "1" : "2",
    "push_token": pushToken,
    "vehicle_number":bikenumber,
    "oem_id":manufactId,
    "vehicle_type_id":vehicleTypeId,
    "vehicle_model_id":modelId
  };

  final client = new http.Client();

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  Map<String, dynamic> responseJson = {};

  try {
    print(pushToken.toString());
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
