import 'dart:convert';

import 'package:http/http.dart' as http;

import '/config/global_config.dart';

Future<Map<String, dynamic>> categoryProductsRequest(
  int idCategory,
  int idLang,
  int limit,
  int offset,
  int type,
  String search,
  int sortType,
  double maxPrice,
  double minPrice,
  String shopId,
  List<int> brandIds,
) async {
  String url = "$GLOBAL_URL/category/products";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final client = http.Client();

  Map<String, String> body = {
    "id_category": idCategory.toString(),
    "id_lang": idLang.toString(),
    // "limit": limit.toString(),
    "limit": "10",
    "offset": offset.toString(),
    "type": type.toString(),
    "search": search,
    "sort_type": sortType.toString(),
    "max_price": maxPrice.toString(),
    "min_price": minPrice.toString(),
    "brands": brandIds.join(","),
    "id_shop": shopId.toString(), //updated by ND
  };

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  Map<String, dynamic> responseJson = {};

  print(response.body);

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
