class Shop {
  final int? id;
  final String? name;
  final String? description;
  final String? logoUrl;
  final String? backImageUrl;
  final String? openHours;
  final String? closeHours;
  final int? deliveryType;
  final double? rating;
  final String? address;
  final double? deliveryFee;
  final String? info;
  bool? isDefault;
  int? totalPorts;
  var availablePorts;
  var latitude;
  var longtitude;
  var distance;
  int? tax;

  Shop(
      {this.id,
      this.name,
      this.description,
      this.backImageUrl,
      this.logoUrl,
      this.openHours,
      this.closeHours,
      this.isDefault,
      this.deliveryType,
      this.rating,
      this.address,
      this.deliveryFee,
      this.info,
      this.totalPorts,
      this.availablePorts,
      this.longtitude,
      this.latitude,
      this.distance,
      this.tax});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "backImageUrl": backImageUrl,
      "logoUrl": logoUrl,
      "openHours": openHours,
      "closeHours": closeHours,
      "isDefault": isDefault,
      "deliveryType": deliveryType,
      "rating": rating,
      "address": address,
      "info": info,
      "deliveryFee": deliveryFee,
      "totalPorts": totalPorts,
      "availablePorts": availablePorts,
      "latitude": latitude,
      "longitude": longtitude,
      "tax":tax
    };
  }

  static Shop fromJson(dynamic json) {
    return Shop(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      backImageUrl: json['backImageUrl'],
      logoUrl: json['logoUrl'],
      openHours: json['openHours'],
      closeHours: json['closeHours'],
      isDefault: json['isDefault'],
      deliveryType: json['deliveryType'],
      rating: json['rating'],
      deliveryFee: json['deliveryFee'],
      info: json['info'],
      address: json['address'],
      totalPorts: json["total_ports"],
      availablePorts: json["available_ports"],
      latitude: json["latitude"],
      longtitude: json["longitude"],
      tax:json["tax"]
    );
  }
}
