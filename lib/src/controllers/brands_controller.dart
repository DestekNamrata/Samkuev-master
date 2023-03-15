import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:samku/src/requests/brands_products_request.dart';

import '/src/controllers/language_controller.dart';
import '/src/controllers/product_controller.dart';
import '/src/controllers/shop_controller.dart';
import '/src/models/brand.dart';
import '/src/models/brand_category.dart';
import '/src/models/product.dart';
import '/src/models/shop.dart';
import '/src/requests/brand_categories_request.dart';
import '/src/requests/brands_request.dart';
import '/src/utils/utils.dart';
import '../requests/brands_prod_req_new.dart';

class BrandsController extends GetxController {
  final ShopController shopController = Get.put(ShopController());
  var brandCategoriesList = <BrandCategory>[].obs;
  var homeBrandsList = <Brand>[].obs;
  var allBrands = <Brand>[].obs;
  var brandProductsList = <int, List<Product>>{}.obs;
  var stationList = <int, List<Shop>>{}.obs;
  var activeBrand = Brand().obs;
  var activeCategory = Brand().obs;
  var inActiveCategory = Brand().obs;
  var load = false.obs;
  var isClicked=false.obs;

  final LanguageController languageController = Get.put(LanguageController());
  final ProductController productController = Get.put(ProductController());
  Shop? shop;
  ScrollController? scrollController;

  @override
  void onInit() {
    super.onInit();
    shop = shopController.defaultShop.value;
    if (shop != null && shop!.id != null && brandCategoriesList.length == 0) {
      getBrands(0, 5, 0);
    }
    // getBrandsProducts(17, 10);

    scrollController = new ScrollController()..addListener(_scrollListener);
  }


  @override
  void dispose() {
    scrollController!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    if (scrollController!.position.extentAfter < 500) {
      if (brandProductsList[activeCategory.value.id]!.length % 10 == 0)
        load.value = true;
    }
  }



  @override
  void onReady() {
    super.onReady();

    getBrandCategories();
  }




  void getAllBrands() async {
    List<Brand> brands = await getBrands(0, -1, 0);

    allBrands.value = brands;
  }

  Future<List<Brand>> getBrandsList(id) async {
    int index = brandCategoriesList.indexWhere((element) => element.id == id);
    List<Brand> brandListArray =
        index != -1 ? brandCategoriesList[index].children! : [];

    if (brandListArray.length == 0) {
      brandListArray = await getBrands(id!, -1, 0);
      if (index != -1) brandCategoriesList[index].children = brandListArray;
    }

    int range = brandListArray.length > 3 ? 3 : brandListArray.length;

    if (brandCategoriesList[index].hasLimit!)
      return brandListArray.sublist(0, range);
    else
      return brandListArray;
  }

  void setHasLimit(id) {
    int index = brandCategoriesList.indexWhere((element) => element.id == id);
    if (index > -1) {
      brandCategoriesList[index].hasLimit =
          !brandCategoriesList[index].hasLimit!;
      brandCategoriesList.refresh();
    }
  }

  bool getHasLimit(id) {
    int index = brandCategoriesList.indexWhere((element) => element.id == id);
    if (index > -1) {
      return brandCategoriesList[index].hasLimit!;
    }

    return false;
  }

  Future<List<Brand>> getBrands(int idBrandCategories, int limit, int offset) async {
    //shop = shopController.defaultShop.value;

    List<Brand> brandList = [];

    if (homeBrandsList.length > 0 && idBrandCategories == -1)
      return homeBrandsList;

    Map<String, dynamic> data =
        await brandsRequest(/*shop!.id!*/ 4, idBrandCategories, limit, offset);
    if (data['success']) {
      for (int i = 0; i < data['data'].length; i++) {
        Map<String, dynamic> item = data['data'][i];

        brandList.add(Brand(
            id: int.parse(item['id'].toString()),
            name: item['name'],
            imageUrl: item['image_url']));
      }

      if (idBrandCategories == -1) {
        homeBrandsList.value = brandList;
        homeBrandsList.refresh();
      }
    }

    return brandList;
  }

  Future<List<BrandCategory>> getBrandCategories() async {
    shop = shopController.defaultShop.value;
    List<BrandCategory> brandCategoryList = [];

    if (await Utils.checkInternetConnectivity() &&
        shop != null &&
        shop!.id != null &&
        shop!.id! > 0) {
      Map<String, dynamic> data = await brandCategoriesRequest(
          shop!.id!, languageController.activeLanguageId.value);
      if (data['success']) {
        for (int i = 0; i < data['data'].length; i++) {
          Map<String, dynamic> item = data['data'][i];

          brandCategoryList.add(BrandCategory(
              id: int.parse(item['id'].toString()),
              name: item["language"]['name']));
        }

        brandCategoriesList.value = brandCategoryList;
      }
    }

    return brandCategoryList;
  }

  Future<List<Product>> getBrandsProducts(int idBrand, int limit) async {
    List<Product> brandpList =
        brandProductsList[idBrand] != null ? brandProductsList[idBrand]! : [];

    //if (load.value) {
    Map<String, dynamic> data =
        await /*brandsProductsRequest*/ brandsProductsReqNew(
            idBrand, languageController.activeLanguageId.value);
    // limit,
    // brandProductsList[idBrand]!.length,
    // productController.searchText.value,
    // productController.sortType.value,
    // productController.rangeEndPrice.value,
    // productController.rangeStartPrice.value,
    // productController.filterBrands);
    if (data['success']) {
      for (int i = 0; i < data['data'].length; i++) {
        Map<String, dynamic> item = data['data'][i];

        int id = int.parse(item['id'].toString());

        int index = brandpList.indexWhere((element) => element.id == id);

        int startTime = item['discount'] != null && item['discount'] != null
            ? DateTime.parse(item['discount']['start_time'])
                .toUtc()
                .millisecondsSinceEpoch
            : 0;
        int endTime = item['discount'] != null && item['discount'] != null
            ? DateTime.parse(item['discount']['end_time'])
                .toUtc()
                .millisecondsSinceEpoch
            : 0;

        if (index == -1)
          brandpList.add(Product(
              isCountDown: item['discount'] != null
                  ? int.parse(item['discount']['is_count_down'].toString())
                  : 0,
              startTime: startTime,
              endTime: endTime,
              id: id,
              name: item['language']['name'],
              amount: item['quantity'] != null
                  ? int.parse(item['quantity'].toString())
                  : 0,
              description: item['language']['description'],
              images: item['images'],
              unit: item['units'] != null
                  ? item['units']['language']['name']
                  : "",
              rating: int.parse(item['comments_count'].toString()) > 0
                  ? (double.parse(item['comments_sum_star'].toString()) /
                      double.parse(item['comments_count'].toString()))
                  : 5.0,
              discount: item['discount'] != null
                  ? double.parse(item['discount']['discount_amount'].toString())
                  : 0,
              discountType: item['discount'] != null
                  ? int.parse(item['discount']['discount_type'].toString())
                  : 0,
              hasCoupon: item['coupon'] != null,
              reviewCount: int.parse(item['comments_count'].toString()),
              price: double.parse(item['price'].toString()),
              image: item['images'][0]['image_url']));
      }

      brandProductsList[idBrand] = brandpList;
      brandProductsList.refresh();
      load.value = false;
    }
    //}

    return brandpList;
  }

  //brand wise stations
  Future<List<Shop>> getBrandsStations(int idBrand,List<int> mArraylistBrandIds, int limit,double currentLat,double curentLong) async {
    List<Shop> stations =
    stationList[idBrand] != null ? stationList[idBrand]! : [];
    var formattedBrandIds='';
    //if (load.value) {
    //updated on 16/05/202 by ND for multiple brndids selection
    for(int i=0;i<mArraylistBrandIds.length;i++)
    {
      // s += '$mArraylistFile[], ';
      var brandId=mArraylistBrandIds[i];
      formattedBrandIds+='$brandId,';
    }

    Map<String, dynamic> data =
    await /*brandsProductsRequest*/ brandsProductsReqNew(
        // idBrand, languageController.activeLanguageId.value);
        formattedBrandIds, languageController.activeLanguageId.value);
    // limit,
    // brandProductsList[idBrand]!.length,
    // productController.searchText.value,
    // productController.sortType.value,
    // productController.rangeEndPrice.value,
    // productController.rangeStartPrice.value,
    // productController.filterBrands);
    if (data['success']) {
      for (int i = 0; i < data['data'].length; i++) {
        Map<String, dynamic> item = data['data'][i];

        int id = int.parse(item['id'].toString());

        int index = stations.indexWhere((element) => element.id == id);

        // int startTime = item['discount'] != null && item['discount'] != null
        //     ? DateTime.parse(item['discount']['start_time'])
        //     .toUtc()
        //     .millisecondsSinceEpoch
        //     : 0;
        // int endTime = item['discount'] != null && item['discount'] != null
        //     ? DateTime.parse(item['discount']['end_time'])
        //     .toUtc()
        //     .millisecondsSinceEpoch
        //     : 0;

        if (index == -1) {
          double distanceInKms=await _getGeoLocationPosition(double.parse(item['latitude'].toString()),double.parse(item['longtitude'].toString()),currentLat,curentLong);
          if(distanceInKms<=10){
            stations.add(
                Shop(
                    isDefault: true,
                    name: item['language']['name'],
                    description: item['language']['description'],
                    logoUrl:item['logo_url'],
                    id: item['id'],
                    backImageUrl: item['backimage_url'],
                    info: item['language']['info'],
                    address: item['language']['address'],
                    deliveryFee: double.parse(
                        item['delivery_price'].toString()),
                    deliveryType:
                    int.parse(item['delivery_type'].toString()),
                    rating: 5, //double.parse(shopData['rating'].toString()),
                    openHours: item['open_hour'].substring(0, 5),
                    closeHours: item['close_hour'].substring(0, 5),
                    totalPorts: item["total_ports"],
                    availablePorts: item["available_ports"],
                    latitude: item['latitude'],
                    longtitude: item['longtitude'],
                    distance:distanceInKms
                )
            );
          }
        }

        print("stations:---"+stations.toString());
      }

      stationList[idBrand] = stations;
      stationList.refresh();
      load.value = false;
    }
    //}

    return stations;
  }

  Future<List<Shop>> getDefaultStations(double currentLat,double curentLong) async {
    List<Shop> stations = [];


    Map<String, dynamic> data =
    await /*brandsProductsRequest*/ brandsProductsReqNew(
      // idBrand, languageController.activeLanguageId.value);
        "", languageController.activeLanguageId.value);
    // limit,
    // brandProductsList[idBrand]!.length,
    // productController.searchText.value,
    // productController.sortType.value,
    // productController.rangeEndPrice.value,
    // productController.rangeStartPrice.value,
    // productController.filterBrands);
    if (data['success']) {
      for (int i = 0; i < data['data'].length; i++) {
        Map<String, dynamic> item = data['data'][i];

        int id = int.parse(item['id'].toString());

        int index = stations.indexWhere((element) => element.id == id);

        // int startTime = item['discount'] != null && item['discount'] != null
        //     ? DateTime.parse(item['discount']['start_time'])
        //     .toUtc()
        //     .millisecondsSinceEpoch
        //     : 0;
        // int endTime = item['discount'] != null && item['discount'] != null
        //     ? DateTime.parse(item['discount']['end_time'])
        //     .toUtc()
        //     .millisecondsSinceEpoch
        //     : 0;

        if (index == -1) {
          double distanceInKms=await _getGeoLocationPosition(double.parse(item['latitude'].toString()),double.parse(item['longtitude'].toString()),currentLat,curentLong);
          if(distanceInKms<=10){
            stations.add(
                Shop(
                    isDefault: true,
                    name: item['language']['name'],
                    description: item['language']['description'],
                    logoUrl:item['logo_url'],
                    id: item['id'],
                    backImageUrl: item['backimage_url'],
                    info: item['language']['info'],
                    address: item['language']['address'],
                    deliveryFee: double.parse(
                        item['delivery_price'].toString()),
                    deliveryType:
                    int.parse(item['delivery_type'].toString()),
                    rating: 5, //double.parse(shopData['rating'].toString()),
                    openHours: item['open_hour'].substring(0, 5),
                    closeHours: item['close_hour'].substring(0, 5),
                    totalPorts: item["total_ports"],
                    availablePorts: item["available_ports"],
                    latitude: item['latitude'],
                    longtitude: item['longtitude'],
                    distance:distanceInKms
                )
            );
          }
        }

        print("stations:---"+stations.toString());
      }

      stationList.refresh();
      load.value = false;
    }
    //}

    return stations;
  }

  Future<double> _getGeoLocationPosition(double latitude,double longitude,double currentLat,double currentLong) async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
    //     .then((Position position) {
    //   widget._currentPosition = position;
    //   print(widget._currentPosition);
     double _distanceInMeters = Geolocator.distanceBetween(
       latitude,
        longitude,
        currentLat,
        currentLong,
     );

      double distanceInKiloMeters = _distanceInMeters / 1000;
      double roundDistanceInKM = double.parse((distanceInKiloMeters).toStringAsFixed(2));
      return roundDistanceInKM;
  }



  brandProductsReq(int idBrand, int value, int limit, int length, String value2,
      int value3, double value4, double value5, RxList<int> filterBrands) {}
}
