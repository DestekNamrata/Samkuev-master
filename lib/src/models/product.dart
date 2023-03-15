import '/src/models/extra.dart';

class Product {
  final int? id;
  final String? name;
  final String? image;
  final String? description;
  final double? price;
  double? rating;
  final List<dynamic>? images;
  final double? discount;
  final int? discountType;
  final int? isCountDown;
  final bool? hasCoupon;
  int? reviewCount;
  final String? unit;
  final int? amount;
  int? count;
  List<Extra>? extras;
  int? startTime;
  int? endTime;
  String? chargingType;
  String? statusName;
  String? power;
  int? status;

  Product({
    this.id,
    this.hasCoupon = false,
    this.name,
    this.description,
    this.image,
    this.price,
    this.discount,
    this.discountType,
    this.images,
    this.isCountDown = 0,
    this.rating,
    this.reviewCount,
    this.unit,
    this.amount,
    this.count = 0,
    this.startTime,
    this.endTime,
    this.extras,
    this.chargingType,
    this.statusName,
    this.power,
    this.status,
  });

  Map<String, dynamic> toJson() {
    double discountPrice = 0;
    if (discountType == 1)
      discountPrice = (price! * discount!) / 100;
    else if (discountType == 2) discountPrice = price! - discount!;

    return {
      "id": id,
      "count": count,
      "price": price,
      "discount": discountPrice,
      "extras": extras != null ? extras!.map((e) => e.toJson()).toList() : []
    };
  }
}
// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

// class Product {
//   Product({
//     this.id,
//     this.quantity,
//     this.packQuantity,
//     this.weight,
//     this.price,
//     this.discountPrice,
//     this.showType,
//     this.active,
//     this.createdAt,
//     this.updatedAt,
//     this.idUnit,
//     this.idCategory,
//     this.idShop,
//     this.idBrand,
//     this.status,
//     this.power,
//     this.commentsCount,
//     this.commentsSumStar,
//     this.chargingType,
//     this.statusName,
//     this.images,
//     this.coupon,
//     this.units,
//     this.discount,
//     this.language, int isCountDown,
//   });

//   int? id;
//   int? quantity;
//   int? packQuantity;
//   int? weight;
//   int? price;
//   int? discountPrice;
//   int? showType;
//   int? active;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? idUnit;
//   int? idCategory;
//   int? idShop;
//   int? idBrand;
//   int? status;
//   String? power;
//   int? commentsCount;
//   dynamic? commentsSumStar;
//   String? chargingType;
//   String? statusName;
//   List<Image>? images;
//   dynamic? coupon;
//   Units? units;
//   dynamic? discount;
//   ProductLanguage? language;

//   // factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

//   // String toRawJson() => json.encode(toJson());

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         id: json["id"],
//         quantity: json["quantity"],
//         packQuantity: json["pack_quantity"],
//         weight: json["weight"],
//         price: json["price"],
//         discountPrice: json["discount_price"],
//         showType: json["show_type"],
//         active: json["active"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//         idUnit: json["id_unit"],
//         idCategory: json["id_category"],
//         idShop: json["id_shop"],
//         idBrand: json["id_brand"],
//         status: json["status"],
//         power: json["power"],
//         commentsCount: json["comments_count"],
//         commentsSumStar: json["comments_sum_star"],
//         chargingType: json["charging_type"],
//         statusName: json["status_name"],
//         images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
//         coupon: json["coupon"],
//         units: Units.fromJson(json["units"]),
//         discount: json["discount"],
//         language: ProductLanguage.fromJson(json["language"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "quantity": quantity,
//         "pack_quantity": packQuantity,
//         "weight": weight,
//         "price": price,
//         "discount_price": discountPrice,
//         "show_type": showType,
//         "active": active,
//         "created_at": createdAt?.toIso8601String(),
//         "updated_at": updatedAt?.toIso8601String(),
//         "id_unit": idUnit,
//         "id_category": idCategory,
//         "id_shop": idShop,
//         "id_brand": idBrand,
//         "status": status,
//         "power": power,
//         "comments_count": commentsCount,
//         "comments_sum_star": commentsSumStar,
//         "charging_type": chargingType,
//         "status_name": statusName,
//         "images": List<dynamic>.from(images!.map((x) => x.toJson())),
//         "coupon": coupon,
//         "units": units?.toJson(),
//         "discount": discount,
//         "language": language?.toJson(),
//       };
// }

// class Image {
//   Image({
//     this.id,
//     this.imageUrl,
//     this.main,
//     this.idProduct,
//   });

//   int? id;
//   String? imageUrl;
//   int? main;
//   int? idProduct;

//   // factory Image.fromRawJson(String str) => Image.fromJson(json.decode(str));

//   // String toRawJson() => json.encode(toJson());

//   factory Image.fromJson(Map<String, dynamic> json) => Image(
//         id: json["id"],
//         imageUrl: json["image_url"],
//         main: json["main"],
//         idProduct: json["id_product"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "image_url": imageUrl,
//         "main": main,
//         "id_product": idProduct,
//       };
// }

// class ProductLanguage {
//   ProductLanguage({
//     this.id,
//     this.name,
//     this.description,
//     this.idProduct,
//     this.idLang,
//   });

//   int ?id;
//   String? name;
//   String? description;
//   int? idProduct;
//   int ?idLang;

//   // factory ProductLanguage.fromRawJson(String str) =>
//   //     ProductLanguage.fromJson(json.decode(str));

//   // String toRawJson() => json.encode(toJson());

//   factory ProductLanguage.fromJson(Map<String, dynamic> json) =>
//       ProductLanguage(
//         id: json["id"],
//         name: json["name"],
//         description: json["description"],
//         idProduct: json["id_product"],
//         idLang: json["id_lang"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "description": description,
//         "id_product": idProduct,
//         "id_lang": idLang,
//       };
// }

// class Units {
//   Units({
//     this.id,
//     this.active,
//     this.language,
//   });

//   int? id;
//   int? active;
//   UnitsLanguage? language;

//   // factory Units.fromRawJson(String str) => Units.fromJson(json.decode(str));

//   // String toRawJson() => json.encode(toJson());

//   factory Units.fromJson(Map<String, dynamic> json) => Units(
//         id: json["id"],
//         active: json["active"],
//         language: UnitsLanguage.fromJson(json["language"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "active": active,
//         "language": language!.toJson(),
//       };
// }

// class UnitsLanguage {
//   UnitsLanguage({
//     this.id,
//     this.name,
//     this.idUnit,
//     this.idLang,
//   });

//   int? id;
//   String? name;
//   int? idUnit;
//   int? idLang;

//   // factory UnitsLanguage.fromRawJson(String str) =>
//   //     UnitsLanguage.fromJson(json.decode(str));

//   // String toRawJson() => json.encode(toJson());

//   factory UnitsLanguage.fromJson(Map<String, dynamic> json) => UnitsLanguage(
//         id: json["id"],
//         name: json["name"],
//         idUnit: json["id_unit"],
//         idLang: json["id_lang"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "id_unit": idUnit,
//         "id_lang": idLang,
//       };
// }
