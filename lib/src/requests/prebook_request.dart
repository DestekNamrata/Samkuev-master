import 'dart:convert';

import '/config/global_config.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> preBookRequest(
    int userId, int status, int idLang, int limit, int offset,int isTabFlag) async {
  String url = "$GLOBAL_URL/order/prebooked";

  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Accept": "application/json"
  };

  final client = new http.Client();

  Map<String, String> body = {
    "id_user": userId.toString(),
    "status": status.toString(),
    "id_lang": idLang.toString(),
    "limit": limit.toString(),
    "offset": offset.toString(),
    "is_today": isTabFlag.toString()
  };

  final response = await client.post(Uri.parse(url),
      headers: headers, body: json.encode(body));

  print(response.body);
  print(body);

  Map<String, dynamic> responseJson = {"success": false};

  try {
    if (response.statusCode == 200)
      responseJson = json.decode(response.body) as Map<String, dynamic>;
  } on FormatException catch (e) {
    print(e);
  }

  return responseJson;
}
