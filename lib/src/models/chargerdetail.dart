// To parse this JSON data, do
//
//     final chargeDetails = chargeDetailsFromJson(jsonString);

import 'dart:convert';

ChargeDetails chargeDetailsFromJson(String str) =>
    ChargeDetails.fromJson(json.decode(str));

String chargeDetailsToJson(ChargeDetails data) => json.encode(data.toJson());

class ChargeDetails {
  ChargeDetails({
    this.id,
    this.quantity,
    this.packQuantity,
    this.weight,
    this.price,
    this.discountPrice,
    this.showType,
    this.active,
    this.createdAt,
    this.updatedAt,
    this.idUnit,
    this.idCategory,
    this.idShop,
    this.idBrand,
    this.status,
    this.power,
    this.statusName,
    this.chargingType,
    this.language,
    this.images,
  });

  int? id;
  int? quantity;
  int? packQuantity;
  int? weight;
  int? price;
  int? discountPrice;
  int? showType;
  int? active;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? idUnit;
  int? idCategory;
  int? idShop;
  int? idBrand;
  int? status;
  String? power;
  String? statusName;
  String? chargingType;
  Language? language;
  List<Image>? images;

  factory ChargeDetails.fromJson(Map<String, dynamic> json) => ChargeDetails(
        id: json["id"],
        quantity: json["quantity"],
        packQuantity: json["pack_quantity"],
        weight: json["weight"],
        price: json["price"],
        discountPrice: json["discount_price"],
        showType: json["show_type"],
        active: json["active"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        idUnit: json["id_unit"],
        idCategory: json["id_category"],
        idShop: json["id_shop"],
        idBrand: json["id_brand"],
        status: json["status"],
        power: json["power"],
        statusName: json["status_name"],
        chargingType: json["charging_type"],
        language: Language.fromJson(json["language"]),
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "pack_quantity": packQuantity,
        "weight": weight,
        "price": price,
        "discount_price": discountPrice,
        "show_type": showType,
        "active": active,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "id_unit": idUnit,
        "id_category": idCategory,
        "id_shop": idShop,
        "id_brand": idBrand,
        "status": status,
        "power": power,
        "status_name": statusName,
        "charging_type": chargingType,
        "language": language!.toJson(),
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class Image {
  Image({
    this.id,
    this.imageUrl,
    this.main,
    this.idProduct,
  });

  int? id;
  String? imageUrl;
  int? main;
  int? idProduct;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: json["id"],
        imageUrl: json["image_url"],
        main: json["main"],
        idProduct: json["id_product"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image_url": imageUrl,
        "main": main,
        "id_product": idProduct,
      };
}

class Language {
  Language({
    this.id,
    this.name,
    this.description,
    this.idProduct,
    this.idLang,
  });

  int? id;
  String? name;
  String? description;
  int? idProduct;
  int? idLang;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        idProduct: json["id_product"],
        idLang: json["id_lang"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "id_product": idProduct,
        "id_lang": idLang,
      };
}
