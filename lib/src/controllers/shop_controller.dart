import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/src/controllers/address_controller.dart';
import '/src/controllers/auth_controller.dart';
import '/src/controllers/banner_controller.dart';
import '/src/controllers/brands_controller.dart';
import '/src/controllers/cart_controller.dart';
import '/src/controllers/category_controller.dart';
import '/src/controllers/chat_controller.dart';
import '/src/controllers/language_controller.dart';
import '/src/controllers/notification_controller.dart';
import '/src/models/shop.dart';
import '/src/models/time_unit.dart';
import '/src/models/user.dart';
import '/src/requests/shop_categories_request.dart';
import '/src/requests/shop_timeunits.dart';
import '/src/requests/shops_request.dart';
import '/src/utils/utils.dart';

class ShopController extends GetxController with SingleGetTickerProviderMixin {
  final AuthController authController = Get.put(AuthController());
  final AddressController addressController = Get.put(AddressController());
  final LanguageController languageController = Get.put(LanguageController());
  TabController? tabController;
  var user = Rxn<Users>();

  var deliveryType = 1.obs;
  var categoryList = [].obs;
  var shopList = [].obs;
  var savedShopList = RxList<Shop>();
  var stationList = [].obs;

  var shopCategory = (-1).obs;
  var shopTimeUnitsList = <TimeUnit>[].obs;
  var offset = 0.obs;
  var deliveryDate = "".obs;
  var deliveryTime = 0.obs;
  var deliveryDateString = "".obs;
  var deliveryTimeString = "".obs;
  var loading = false.obs;
  var defaultShop = Rxn<Shop>();

  @override
  void onInit() {
    super.onInit();

    tabController = new TabController(length: 2, vsync: this);
    user.value = authController.getUser();


    this.getSavedShopList();
    this.getShopCategories();
    this.getShops();
  }

  List<Shop> get shops => this.savedShopList;

  void getSavedShopList() {
    final box = GetStorage();
    List<dynamic> data = box.read("shops") ?? [];

    savedShopList.value =
        data.map<Shop>((item) => Shop.fromJson(item)).toList();
    savedShopList.refresh();

    if (shopTimeUnitsList.length == 0) {
      int indexDefault =
          savedShopList.indexWhere((item) => item.isDefault == true);
      if (indexDefault > -1) {
        getTimeUnits(savedShopList[indexDefault].id!);
      }
    }
  }

  Future<void> getShops() async {
    user.value = authController.getUser();

    if (await Utils.checkInternetConnectivity()) {
      Map<String, dynamic> data = await shopsRequest(
          shopCategory.value,
          languageController.activeLanguageId.value,
          deliveryType.value,
          offset.value,
          10);
      print("------------------shopsRequest-------------------------");
      print(data['data'].toString());
      if (data['success']) {
        shopList.value = data['data'];
        shopList.refresh();
        loading.value = false;

        for (int i = 0; i < savedShopList.length; i++) {
          int index = data['data']
              .indexWhere((element) => element['id'] == savedShopList[i].id);
          if (index == -1) {
            savedShopList.removeAt(i);
            savedShopList.refresh();
          } else {
            print("------------------savedShopList-------------------------");
            print(savedShopList.toList().toString());
            savedShopList[i] =
                Shop(
              isDefault: true,
              name: data['data'][index]['language']['name'],
              description: data['data'][index]['language']['description'],
              logoUrl: data['data'][index]['logo_url'],
              id: data['data'][index]['id'],
              backImageUrl: data['data'][index]['backimage_url'],
              info: data['data'][index]['language']['info'],
              address: data['data'][index]['language']['address'],
              deliveryFee: double.parse(
                  data['data'][index]['delivery_price'].toString()),
              deliveryType:
                  int.parse(data['data'][index]['delivery_type'].toString()),
              rating: 5, //double.parse(shopData['rating'].toString()),
              openHours: data['data'][index]['open_hour'].substring(0, 5),
              closeHours: data['data'][index]['close_hour'].substring(0, 5),
              totalPorts: data["total_ports"],
              availablePorts: data["available_ports"],
            );
          }
        }
      }
    }
  }

  Future<void> getShopCategories() async {
    if (await Utils.checkInternetConnectivity()) {
      Map<String, dynamic> data = await shopCategoriesRequest(
          languageController.activeLanguageId.value);
      if (data['success']) {
        categoryList.value = data['data'];
      }
    }
  }

  void onChangeDeliveryType(deliveryTypeId) {
    deliveryType.value = deliveryTypeId;
    shopList.value = [];
    loading.value = true;

    getShops();
  }

  void onChangeShopCategory(shopCategoryId) {
    shopCategory.value = shopCategoryId;
    shopList.value = [];
    loading.value = true;

    getShops();
  }

  void addToSavedShop(Map<String, dynamic> shopData,String distanceInKm) {
    List<Shop> shops = savedShopList;

    int indexDefault = shops.indexWhere((item) => item.isDefault == true);
    if (indexDefault > -1) {
      shops[indexDefault].isDefault = false;
    }

    Shop shop = Shop(
      isDefault: true,
      name: shopData['language']['name'],
      description: shopData['language']['description'],
      logoUrl: shopData['logo_url'],
      id: shopData['id'],
      backImageUrl: shopData['backimage_url'],
      info: shopData['language']['info'],
      address: shopData['language']['address'],
      deliveryFee: double.parse(shopData['delivery_price'].toString()),
      deliveryType: int.parse(shopData['delivery_type'].toString()),
      rating: 5, //double.parse(shopData['rating'].toString()),
      openHours: shopData['open_hour'].substring(0, 5),
      closeHours: shopData['close_hour'].substring(0, 5),
      totalPorts: shopData["total_ports"],
      availablePorts: shopData["available_ports"],
      distance: distanceInKm,
      tax: shopData["tax"]
    );
    print("distance:-"+distanceInKm.toString());

    int index = shops.indexWhere((item) => item.id == shopData['id']);
    if (index > -1) {
      shops[index] = shop;
    } else {
      shops.add(shop);
    }

    defaultShop.value = shop;

    getTimeUnits(shop.id!);

    final box = GetStorage();
    box.write('shops', shops.map((shop) => shop.toJson()).toList());

    BrandsController brandsController = Get.put(BrandsController());
    BannerController bannerController = Get.put(BannerController());
    CategoryController categoryController = Get.put(CategoryController());
    ChatController chatController = Get.put(ChatController());
    CartController cartController = Get.put(CartController());
    NotificationController notificationController =
        Get.put(NotificationController());

    notificationController.getNotifications();
    cartController.cartProducts.value = [];
    cartController.cartProducts.refresh();

    brandsController.brandCategoriesList.value = [];
    brandsController.brandCategoriesList.refresh();
    brandsController.brandProductsList.value = {};
    brandsController.brandProductsList.refresh();
    brandsController.homeBrandsList.value = [];
    brandsController.homeBrandsList.refresh();
    brandsController.getBrandCategories();
    brandsController.getAllBrands();

    bannerController.bannerList.value = [];
    bannerController.bannerList.refresh();
    bannerController.bannerProducts.value = [];
    bannerController.bannerProducts.refresh();
    bannerController.load.value = true;
    bannerController.load.refresh();
    chatController.getShopUser();

    categoryController.categoryProductList.value = {};
    categoryController.categoryProductList.refresh();
    categoryController.categoryList.value = [];
    categoryController.categoryList.refresh();
    categoryController.getCategories(-1, 10, 0);

    Get.toNamed("/home");
  }

  // void addToSavedStations(Shop stations,String distanceInKm) {
  //   List<Shop> shops = savedShopList;
  //
  //   int indexDefault = shops.indexWhere((item) => item.isDefault == true);
  //   if (indexDefault > -1) {
  //     shops[indexDefault].isDefault = false;
  //   }
  //
  //   Shop shop = Shop(
  //       isDefault: true,
  //       name: stations.name,
  //       description: stations.description,
  //       logoUrl: stations.logoUrl,
  //       id: stations.id,
  //       backImageUrl: stations.backImageUrl,
  //       info: stations.info,
  //       address: stations.address,
  //       deliveryFee: double.parse(stations.deliveryFee.toString()),
  //       deliveryType: int.parse(stations.deliveryType.toString()),
  //       rating: 5, //double.parse(shopData['rating'].toString()),
  //       openHours: stations.openHours.toString().substring(0, 5),
  //       closeHours: stations.closeHours.toString().toString().substring(0, 5),
  //       totalPorts: stations.totalPorts,
  //       availablePorts: stations.availablePorts,
  //       distance: distanceInKm,
  //       tax: stations.tax
  //   );
  //   print("distance:-"+distanceInKm.toString());
  //
  //   int index = shops.indexWhere((item) => item.id == stations.id);
  //   if (index > -1) {
  //     shops[index] = shop;
  //   } else {
  //     shops.add(shop);
  //   }
  //
  //   defaultShop.value = shop;
  //
  //   getTimeUnits(shop.id!);
  //
  //   final box = GetStorage();
  //   box.write('shops', shops.map((shop) => shop.toJson()).toList());
  //
  //   BrandsController brandsController = Get.put(BrandsController());
  //   BannerController bannerController = Get.put(BannerController());
  //   CategoryController categoryController = Get.put(CategoryController());
  //   ChatController chatController = Get.put(ChatController());
  //   CartController cartController = Get.put(CartController());
  //   NotificationController notificationController =
  //   Get.put(NotificationController());
  //
  //   notificationController.getNotifications();
  //   cartController.cartProducts.value = [];
  //   cartController.cartProducts.refresh();
  //
  //   brandsController.brandCategoriesList.value = [];
  //   brandsController.brandCategoriesList.refresh();
  //   brandsController.brandProductsList.value = {};
  //   brandsController.brandProductsList.refresh();
  //   brandsController.homeBrandsList.value = [];
  //   brandsController.homeBrandsList.refresh();
  //   brandsController.getBrandCategories();
  //   brandsController.getAllBrands();
  //
  //   bannerController.bannerList.value = [];
  //   bannerController.bannerList.refresh();
  //   bannerController.bannerProducts.value = [];
  //   bannerController.bannerProducts.refresh();
  //   bannerController.load.value = true;
  //   bannerController.load.refresh();
  //   chatController.getShopUser();
  //
  //   categoryController.categoryProductList.value = {};
  //   categoryController.categoryProductList.refresh();
  //   categoryController.categoryList.value = [];
  //   categoryController.categoryList.refresh();
  //   categoryController.getCategories(-1, 10, 0);
  //
  //   Get.toNamed("/home");
  // }

  //updated on 19/05/2022
  void addToSavedStations(List<Shop> stations,String distanceInKm,int pos) {
    List<Shop> shops = savedShopList;

    int indexDefault = shops.indexWhere((item) => item.isDefault == true);
    if (indexDefault > -1) {
      shops[indexDefault].isDefault = false;
    }

    Shop shop = Shop(
        isDefault: true,
        name: stations[pos].name,
        description: stations[pos].description,
        logoUrl: stations[pos].logoUrl,
        id: stations[pos].id,
        backImageUrl: stations[pos].backImageUrl,
        info: stations[pos].info,
        address: stations[pos].address,
        deliveryFee: double.parse(stations[pos].deliveryFee.toString()),
        deliveryType: int.parse(stations[pos].deliveryType.toString()),
        rating: 5, //double.parse(shopData['rating'].toString()),
        openHours: stations[pos].openHours!.substring(0, 5),
        closeHours: stations[pos].closeHours!.substring(0, 5),
        totalPorts: stations[pos].totalPorts,
        availablePorts: stations[pos].availablePorts,
        distance: distanceInKm,
      tax: stations[pos].tax
    );
    print("distance:-"+distanceInKm.toString());

    int index = shops.indexWhere((item) => item.id == stations[pos].id);
    if (index > -1) {
      shops[index] = shop;
    } else {
      shops.add(shop);
    }

    defaultShop.value = shop;

    getTimeUnits(shop.id!);

    final box = GetStorage();
    box.write('shops', shops.map((shop) => shop.toJson()).toList());

    BrandsController brandsController = Get.put(BrandsController());
    BannerController bannerController = Get.put(BannerController());
    CategoryController categoryController = Get.put(CategoryController());
    ChatController chatController = Get.put(ChatController());
    CartController cartController = Get.put(CartController());
    NotificationController notificationController =
    Get.put(NotificationController());

    notificationController.getNotifications();
    cartController.cartProducts.value = [];
    cartController.cartProducts.refresh();

    brandsController.brandCategoriesList.value = [];
    brandsController.brandCategoriesList.refresh();
    brandsController.brandProductsList.value = {};
    brandsController.brandProductsList.refresh();
    brandsController.homeBrandsList.value = [];
    brandsController.homeBrandsList.refresh();
    brandsController.getBrandCategories();
    brandsController.getAllBrands();

    bannerController.bannerList.value = [];
    bannerController.bannerList.refresh();
    bannerController.bannerProducts.value = [];
    bannerController.bannerProducts.refresh();
    bannerController.load.value = true;
    bannerController.load.refresh();
    chatController.getShopUser();

    categoryController.categoryProductList.value = {};
    categoryController.categoryProductList.refresh();
    categoryController.categoryList.value = [];
    categoryController.categoryList.refresh();
    categoryController.getCategories(-1, 10, 0);

    Get.offAndToNamed("/home");
  }


  void setDefaultShop(int index) {
    int indexDefault =
        savedShopList.indexWhere((item) => item.isDefault == true);
    if (indexDefault > -1 && savedShopList.length > index) {
      savedShopList[indexDefault].isDefault = false;
    }

    if (savedShopList.length > index) {
      savedShopList[index].isDefault = true;
      defaultShop.value = savedShopList[index];

      getTimeUnits(savedShopList[index].id!);
    }

    final box = GetStorage();
    box.write('shops', savedShopList.map((shop) => shop.toJson()).toList());
    print(savedShopList.toString());
    BrandsController brandsController = Get.put(BrandsController());
    BannerController bannerController = Get.put(BannerController());
    CategoryController categoryController = Get.put(CategoryController());
    ChatController chatController = Get.put(ChatController());
    CartController cartController = Get.put(CartController());
    NotificationController notificationController =
        Get.put(NotificationController());

    notificationController.getNotifications();
    cartController.cartProducts.value = [];
    cartController.cartProducts.refresh();

    brandsController.brandCategoriesList.value = [];
    brandsController.brandCategoriesList.refresh();
    brandsController.brandProductsList.value = {};
    brandsController.brandProductsList.refresh();
    brandsController.homeBrandsList.value = [];
    brandsController.homeBrandsList.refresh();
    brandsController.getBrandCategories();
    brandsController.getAllBrands();

    bannerController.bannerList.value = [];
    bannerController.bannerList.refresh();
    bannerController.bannerProducts.value = [];
    bannerController.bannerProducts.refresh();
    bannerController.load.value = true;
    bannerController.load.refresh();
    chatController.getShopUser();

    categoryController.categoryProductList.value = {};
    categoryController.categoryProductList.refresh();
    categoryController.categoryList.value = [];
    categoryController.categoryList.refresh();
    categoryController.getCategories(-1, 10, 0);

    Get.toNamed("/home");
  }

  Future<void> getTimeUnits(int shopId) async {
    List<TimeUnit> timeUnits = [];

    Map<String, dynamic> data = await shopsTimeUnitsRequest(shopId);
    if (data['success']) {
      for (int i = 0; i < data['data'].length; i++) {
        Map<String, dynamic> item = data['data'][i];
        timeUnits.add(TimeUnit(id: item['id'], name: item['name']));
      }

      shopTimeUnitsList.value = timeUnits;
      shopTimeUnitsList.refresh();
    }
  }
}
