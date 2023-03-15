class VehicleModelResp {
  String? message;
  List<Model>? data;
  bool? success;
  int? code;

  VehicleModelResp({this.message, this.data, this.success, this.code});

  VehicleModelResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Model>[];
      json['data'].forEach((v) {
        data!.add(new Model.fromJson(v));
      });
    }
    success = json['success'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['success'] = this.success;
    data['code'] = this.code;
    return data;
  }
}

class Model {
  int? id;
  String? modelName;
  String? modelUrl;
  int? vehicleTypeId;
  int? oemId;
  String? vehicleRange;
  String? maxSpeed;
  String? acceleration;
  String? warranty;
  String? consumption;
  String? batteryTechnology;
  String? batteryCapacity;
  String? batteryDensity;
  String? batteryCycle;
  String? createdAt;
  String? updatedAt;

  Model(
      {this.id,
        this.modelName,
        this.modelUrl,
        this.vehicleTypeId,
        this.oemId,
        this.vehicleRange,
        this.maxSpeed,
        this.acceleration,
        this.warranty,
        this.consumption,
        this.batteryTechnology,
        this.batteryCapacity,
        this.batteryDensity,
        this.batteryCycle,
        this.createdAt,
        this.updatedAt});

  Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modelName = json['model_name'];
    modelUrl = json['model_url'];
    vehicleTypeId = json['vehicle_type_id'];
    oemId = json['oem_id'];
    vehicleRange = json['vehicle_range'];
    maxSpeed = json['max_speed'];
    acceleration = json['acceleration'];
    warranty = json['warranty'];
    consumption = json['consumption'];
    batteryTechnology = json['battery_technology'];
    batteryCapacity = json['battery_capacity'];
    batteryDensity = json['battery_density'];
    batteryCycle = json['battery_cycle'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['model_name'] = this.modelName;
    data['model_url'] = this.modelUrl;
    data['vehicle_type_id'] = this.vehicleTypeId;
    data['oem_id'] = this.oemId;
    data['vehicle_range'] = this.vehicleRange;
    data['max_speed'] = this.maxSpeed;
    data['acceleration'] = this.acceleration;
    data['warranty'] = this.warranty;
    data['consumption'] = this.consumption;
    data['battery_technology'] = this.batteryTechnology;
    data['battery_capacity'] = this.batteryCapacity;
    data['battery_density'] = this.batteryDensity;
    data['battery_cycle'] = this.batteryCycle;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
