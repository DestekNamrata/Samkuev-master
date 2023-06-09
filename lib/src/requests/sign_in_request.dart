import 'dart:convert';

import '/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> signInRequest(
    String phone, String password, String pushToken) async {
  String url = "$GLOBAL_URL/client/login";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  Map<String, String> body = {
    "phone": phone,
    // "password": password,
    "push_token": pushToken,
    "login_token":"eSWOiBetdOO1dvK1LHGcunP0KwI2as"


  };

  // if (socialId.length > 0)
  //   body = {"social_id": socialId, "push_token": pushToken};

  final client = new http.Client(); //91 520 84 73

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  print(body);
  print(response.body);

  Map<String, dynamic> responseJson = {};

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
