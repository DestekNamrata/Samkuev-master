// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:samku/src/controllers/currency_controller.dart';
// import 'package:samku/src/controllers/language_controller.dart';
// import 'package:samku/src/controllers/product_controller.dart';
// import 'package:samku/src/controllers/shop_controller.dart';
// import 'package:samku/src/models/chargerdetail.dart';
// import 'package:samku/src/models/shop.dart';
// import 'package:samku/src/requests/chargeingdetails_request.dart';

// class ChargeingDetailsController extends GetxController {
//   final ShopController shopController = Get.put(ShopController());
//   final CurrencyController currencyController = Get.put(CurrencyController());
//   final LanguageController languageController = Get.put(LanguageController());
//   final ProductController productController = Get.put(ProductController());
//   var ChargeDetailsList = <ChargeDetails>[].obs;

//   // var homeCategoryProductList = <int, List<Product>>{}.obs;
//   // var categoryProductList = <int, List<Product>>{}.obs;
//   Shop? shop;
//   ScrollController? scrollController;
//   ScrollController? subScrollController;
//   // var activeCategory = Category().obs;
//   // var inActiveCategory = Category().obs;
//   var load = false.obs;
//   var typing = false.obs;

//   Future<List<ChargeDetails>> getCategoryProducts(
//       int idCategory, bool isMain) async {
//     List<ChargeDetails> chargeDetailsList = [];
//     int offset = 0;

//     // if (!isMain && categoryProductList[idCategory] != null) {
//     //   productList = categoryProductList[idCategory]!;
//     //   offset = categoryProductList[idCategory]!.length;
//     // }

//     // if (homeCategoryProductList[idCategory] != null &&
//     //     homeCategoryProductList[idCategory]!.length > 0 &&
//     //     isMain) return homeCategoryProductList[idCategory]!;

//     if (offset == 0 && isMain) load.value = true;

//     if (load.value) {
//       Map<String, dynamic> data = await chargeingdetailsrequest(
//         languageController.activeLanguageId.value,
//         productController.activeProduct.value.id,
//       );
//       if (data['success']) {
//         for (int i = 0; i < data['data'].length; i++) {
//           Map<String, dynamic> item = data['data'][i];

//           int id = int.parse(item['id'].toString());

//           int index = chargeDetailsList.indexWhere((element) => element.id == id);
//           double tax = item['category']['taxes'].length > 0
//               ? item['category']['taxes'].fold(0, (a, b) => a + b['percent'])
//               : 0;

//           int startTime = item['discount'] != null
//               ? DateTime.parse(item['discount']['start_time'])
//                   .toUtc()
//                   .millisecondsSinceEpoch
//               : 0;
//           int endTime = item['discount'] != null
//               ? DateTime.parse(item['discount']['end_time'])
//                   .toUtc()
//                   .millisecondsSinceEpoch
//               : 0;

//           if (index == -1)
//             chargeDetailsList.add(ChargeDetails(
//               chargingType:item[''],
//                 // isCountDown: item['discount'] != null
//                 //     ? int.parse(item['discount']['is_count_down'].toString())
//                 //     : 0,
//                 // name: item['language']['name'],
//                 // description: item['language']['description'],
//                 // amount: int.parse(item['quantity'].toString()),
//                 // image: item['images'][0]['image_url'],
//                 // images: item['images'],
//                 // startTime: startTime,
//                 // endTime: endTime,
//                 // tax: tax,
//                 // unit: item['units'] != null
//                 //     ? item['units']['language']['name']
//                 //     : "",
//                 // rating: int.parse(item['comments_count'].toString()) > 0
//                 //     ? (int.parse(item['comments_sum_star'].toString()) /
//                 //         int.parse(item['comments_count'].toString()))
//                 //     : 5.0,
//                 // price: double.parse(item['price'].toString()),
//                 // discount: item['discount'] != null
//                 //     ? double.parse(
//                 //         item['discount']['discount_amount'].toString())
//                 //     : 0,
//                 // discountType: item['discount'] != null
//                 //     ? int.parse(item['discount']['discount_type'].toString())
//                 //     : 0,
//                 // hasCoupon: item['coupon'] != null,
//                 // reviewCount: int.parse(item['comments_count'].toString()),
//                 id: id));
//         }

//         if (isMain) {
//           homeCategoryProductList[idCategory] = productList;
//           homeCategoryProductList.refresh();
//         } else {
//           categoryProductList[idCategory] = productList;
//           categoryProductList.refresh();
//         }
//       }

//       load.value = false;
//     }

//     return productList;
//   }
// }
