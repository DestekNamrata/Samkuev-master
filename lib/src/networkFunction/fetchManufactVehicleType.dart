import 'package:samku/src/requests/manufacture_request.dart';
import 'package:samku/src/utils/utils.dart';

import '../models/manufacture_model.dart';

Future<List<Data>> fetchManufactVehicleTye(String url) async {
  List<Data> manufacture = [];

  if (await Utils.checkInternetConnectivity()) {
    Map<String, dynamic> data = await manufactureRequest(url);
    if (data['success']) {
      //if (data['data'].length > 0) {
      for (int i = 0; i < data['data'].length; i++) {
        Map<String, dynamic> item = data['data'][i];

        int id = int.parse(item['id'].toString());

        int index = manufacture.indexWhere((element) => element.id == id);

        if (index == -1)
          manufacture.add(Data(
            id: id,
            name: item['name'],
          ));
      }
    }
  }
  return manufacture;
}
