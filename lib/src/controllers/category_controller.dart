import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/src/controllers/currency_controller.dart';
import '/src/controllers/language_controller.dart';
import '/src/controllers/product_controller.dart';
import '/src/controllers/shop_controller.dart';
import '/src/models/category.dart';
import '/src/models/product.dart';
import '/src/models/shop.dart';
import '/src/requests/category_product_request.dart';
import '/src/requests/category_request.dart';
import '/src/utils/utils.dart';

class CategoryController extends GetxController {
  final ShopController shopController = Get.put(ShopController());
  final CurrencyController currencyController = Get.put(CurrencyController());
  final LanguageController languageController = Get.put(LanguageController());
  final ProductController productController = Get.put(ProductController());
  var categoryList = <Category>[].obs;
  var tabIndex = 0.obs;
  var isSelectedIndex = 0.obs;
  List<String> tabs = ["Car".tr, "Bike".tr, "Battery".tr];
  var homeCategoryProductList = <int, List<Product>>{}.obs;
  var categoryProductList = <int, List<Product>>{}.obs;
  Shop? shop;
  ScrollController? scrollController;
  ScrollController? subScrollController;
  var activeCategory = Category().obs;
  var inActiveCategory = Category().obs;
  var load = false.obs;
  var typing = false.obs;
  var qrData;

  @override
  void onInit() {
    super.onInit();

    scrollController = new ScrollController()..addListener(_scrollListener);
    subScrollController = new ScrollController()
      ..addListener(_subScrollListener);

    shop = shopController.defaultShop.value;
    if (shop != null && shop!.id != null && categoryList.length == 0) {
      getCategories(-1, 10, 0);
    }
    //updated on 25/03/2022 by ND
    getCategoryProducts(1, false);
  }

  @override
  void dispose() {
    scrollController!.removeListener(_scrollListener);
    subScrollController!.removeListener(_subScrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController!.position.extentAfter < 500) {
      if (categoryProductList[activeCategory.value.id]!.length % 10 == 0)
        load.value = true;
    }
  }

  void _subScrollListener() {
    if (subScrollController!.position.extentAfter < 500) {
      if (categoryProductList[activeCategory.value.id]!.length % 10 == 0)
        load.value = true;
    }
  }

  Future<List<Category>> getCategories(
      int idCategory, int limit, int offset) async {
    shop = shopController.defaultShop.value;

    List<Category> categories = [];
    if (await Utils.checkInternetConnectivity() && shop != null) {
      Map<String, dynamic> data = await categoryRequest(shop!.id!, idCategory,
          languageController.activeLanguageId.value, limit, offset);
      if (data['success']) {
        //if (data['data'].length > 0) {
        for (int i = 0; i < data['data'].length; i++) {
          Map<String, dynamic> item = data['data'][i];

          int id = int.parse(item['id'].toString());

          int index = categories.indexWhere((element) => element.id == id);

          if (index == -1)
            categories.add(Category(
              id: id,
              name: item["language"]['name'],
            ));
        }

        if (idCategory == -1) {
          categoryList.value = categories;
          categoryList.refresh();
        }
      }

    }
    return categories;
  }

  Future<List<Product>> getCategoryProducts(int idCategory, bool isMain) async {
    List<Product> productList = [];
    int offset = 0;

    if (!isMain && categoryProductList[idCategory] != null) {
      productList = categoryProductList[idCategory]!;
      offset = categoryProductList[idCategory]!.length;
    }

    if (homeCategoryProductList[idCategory] != null &&
        homeCategoryProductList[idCategory]!.length > 0 &&
        isMain) return homeCategoryProductList[idCategory]!;

    if (offset == 0 && isMain) load.value = true;

    if (load.value) {
      Map<String, dynamic> data = await categoryProductsRequest(
        idCategory,
        languageController.activeLanguageId.value,
        10,
        offset,
        isMain ? tabIndex.value : 0,
        productController.searchText.value,
        productController.sortType.value,
        productController.rangeEndPrice.value,
        productController.rangeStartPrice.value,
        shop!.id.toString(),
        productController.filterBrands,
      );
      if (data['success']) {
        for (int i = 0; i < data['data'].length; i++) {
          Map<String, dynamic> item = data['data'][i];

          int id = int.parse(item['id'].toString());

          int index = productList.indexWhere((element) => element.id == id);

          int startTime = item['discount'] != null
              ? DateTime.parse(item['discount']['start_time'])
                  .toUtc()
                  .millisecondsSinceEpoch
              : 0;
          int endTime = item['discount'] != null
              ? DateTime.parse(item['discount']['end_time'])
                  .toUtc()
                  .millisecondsSinceEpoch
              : 0;

          if (index == -1) {
            productList.add(Product(
                chargingType: item['charging_type'],
                power: item['power'],
                statusName: item['status_name'],
                status: item['status'],
                isCountDown: item['discount'] != null
                    ? int.parse(item['discount']['is_count_down'].toString())
                    : 0,
                name: item['language']!=null?
                item['language']['name']:
                "",
                description: item['language']['description'],
                amount: item['quantity'] != null
                    ? int.parse(item['quantity'].toString())
                    : 0,
                image: item['images'][0]['image_url'],
                images: item['images'],
                startTime: startTime,
                endTime: endTime,
                unit: item['units'] != null
                    ? item['units']['language']['name']
                    : "",
                rating: int.parse(item['comments_count'].toString()) > 0
                    ? (int.parse(item['comments_sum_star'].toString()) /
                        int.parse(item['comments_count'].toString()))
                    : 5.0,
                price: double.parse(item['price'].toString()),
                discount: item['discount'] != null
                    ? double.parse(
                        item['discount']['discount_amount'].toString())
                    : 0,
                discountType: item['discount'] != null
                    ? int.parse(item['discount']['discount_type'].toString())
                    : 0,
                hasCoupon: item['coupon'] != null,
                reviewCount: int.parse(item['comments_count'].toString()),
                id: id));
          }
        }

        if (isMain) {
          homeCategoryProductList[idCategory] = productList;
          homeCategoryProductList.refresh();
        } else {
          categoryProductList[idCategory] = productList;
          categoryProductList.refresh();
        }
      }

      load.value = false;
    }

    return productList;
  }

  void onChangeProductType(index) {
    tabIndex.value = index;

    categoryList.value = [];
    refresh();

    getCategories(-1, 10, 0);

    homeCategoryProductList.value = {};
    homeCategoryProductList.refresh();
  }
}
