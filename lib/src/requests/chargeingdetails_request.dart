import 'dart:convert';

import 'package:samku/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> chargeingdetailsrequest(
    int idLang, int? id) async {
  String url = "$GLOBAL_URL/product/product";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final client = new http.Client();

  Map<String, String> body = {
    "id_product": id.toString(),
    "id_lang": idLang.toString(),
  };

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  Map<String, dynamic> responseJson = {};

  print(body);

  try {
    if (response.statusCode == 200) {
      responseJson = json.decode(response.body);
      print(responseJson.toString());
      //  results = responseJson.map((e) => ChargeDetails.fromJson(e)).toList();
    }
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
