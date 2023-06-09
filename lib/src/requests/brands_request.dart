import 'dart:convert';

import 'package:http/http.dart' as http;

import '/config/global_config.dart';

Future<Map<String, dynamic>> brandsRequest(
    int idShop, int idBrandCategories, int limit, int offset) async {
  String url = "$GLOBAL_URL/brand/get";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final client = new http.Client();

  Map<String, String> body = {
    "id_brand_category": idBrandCategories.toString(),
    "id_shop": /*idShop.toString()*/ "4",
    "limit": limit.toString(),
    "offset": offset.toString()
  };

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

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
