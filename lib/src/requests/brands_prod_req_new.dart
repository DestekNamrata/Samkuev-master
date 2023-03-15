import 'dart:convert';

import 'package:http/http.dart' as http;

import '/config/global_config.dart';

Future<Map<String, dynamic>> brandsProductsReqNew(
  var idBrand,
  int idLang,
  // int limit,
  // int offset,
  // String search,
  // int sortType,
  // double maxPrice,
  // double minPrice,
  // List<int> brandIds) async {
) async {
  String url = "$GLOBAL_URL/brands/shops";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final client = new http.Client();

  Map<String, String> body = {
    "id_brand": idBrand.toString(),
    "id_lang": idLang.toString(),
    // "limit": limit.toString(),
    // "offset": offset.toString(),
    // "search": search,
    // "sort_type": sortType.toString(),
    // "max_price": maxPrice.toString(),
    // "min_price": minPrice.toString(),
    // "brands": brandIds.join(",")
  };

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));
  print(body);
  print(response.body);

  Map<String, dynamic> responseJson = {};

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
    print(responseJson);
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
