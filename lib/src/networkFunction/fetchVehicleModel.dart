import 'package:samku/src/models/model_vehicleModel.dart';
import 'package:samku/src/requests/vehicleModel_request.dart';

import '../models/manufacture_model.dart';
import '../utils/utils.dart';

Future<List<Model>> fetchVehicleModel(
    Data? manufactureSelected, Data? vehicleTypeSelected) async {
  List<Model> vehicleModel = [];
  // print("manufa:-" +
  //     manufactureSelected!.id.toString() +
  //     " vehicleTye:-" +
  //     vehicleTypeSelected!.id.toString());

  if (await Utils.checkInternetConnectivity()) {
    Map<String, dynamic> data = await vehicleModelRequest(
        manufactureSelected != null ? manufactureSelected.id.toString() : "",
        vehicleTypeSelected != null ? vehicleTypeSelected.id.toString() : "");
    if (data['success']) {
      if (data['data'].length > 0) {
        for (int i = 0; i < data['data'].length; i++) {
          Map<String, dynamic> item = data['data'][i];

          int id = int.parse(item['id'].toString());

          int index = vehicleModel.indexWhere((element) => element.id == id);

          if (index == -1)
            vehicleModel.add(Model(
              id: id,
              modelName: item['model_name'],
            ));
        }
      } else {
        print("getting no data");
        Model vehicle_Model = Model();
        vehicle_Model.modelName = '';
        vehicleModel.add(vehicle_Model);
      }
    }
  }
  return vehicleModel;
}
