import 'dart:async';
import 'dart:convert';
import 'dart:io';



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:samku/src/components/appbar.dart';
import 'package:samku/src/components/empty.dart';
import 'package:samku/src/controllers/address_controller.dart';
import 'package:samku/src/controllers/brands_controller.dart';
import 'package:samku/src/models/brand.dart';
import 'package:samku/src/models/shop.dart';
import 'package:samku/src/pages/location.dart';
import 'package:samku/src/requests/brands_prod_req_new.dart';
import 'package:samku/src/requests/brands_request.dart';

import '/src/components/shops_location_item.dart';
import '/src/controllers/shop_controller.dart';
import '/src/themes/map_dark_theme.dart';
import '/src/themes/map_light_theme.dart';
import '../components/shadows/category_product_item_shadow.dart';
import 'dart:ui' as ui;


class StoreLocationUpdated extends StatefulWidget {
  @override
  StoreLocationUpdatedState createState() => StoreLocationUpdatedState();
}

class StoreLocationUpdatedState extends State<StoreLocationUpdated> {
  final ShopController shopController = Get.put(ShopController());
  final BrandsController bController = Get.put(BrandsController());
  final AddressController controller = Get.put(AddressController());


  BitmapDescriptor? pinLocationIcon;
  Completer<GoogleMapController> _controller = Completer();
  bool loadGoogleMap = false;
  late double latitude, longitude;
  Map<MarkerId, Marker> markers = {};
  List<Shop> stations = [];
  List<Shop> markerStations = [];
  List<int> mArraylistBrandIds=[];
  List<Brand> brandList = [];
  List<Brand> allBrandList = [];
  bool isClicked=false;
  bool flagStart=true;

  int id = 17;
  List<String> tabs = [
    "Near you".tr,
    "AC 3 pin".tr,
    "AC Type 1".tr,
    "AC Type 2".tr,
    "DC CHAdeMO".tr,
    "DC combo2".tr
  ];
  var tabIndex = 0.obs;
  late Position _currentPosition;
  bool flagNoDataAvailable=false;
  var _distanceInMeters;


  @override
  void initState() {
    super.initState();
    latitude = shopController.addressController.latitude.value;
    longitude = shopController.addressController.longitude.value;
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        loadGoogleMap = true;
      });
    });
    setCustomMapPin();
  }


  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(0.2, 0.5)),
        'lib/assets/images/Chargestation.png');
    setState(() {
      id = bController.activeBrand.value.id ?? 17;
      mArraylistBrandIds.add(id);
      getBrands(0, 5, 0);

    });

  }

  void _setMarker(List<Shop> markerStations) {
    Map<MarkerId, Marker> markerData = {};

    if (markerStations.length > 0) {
      // ignore: curly_braces_in_flow_control_structures
      for (int i = 0; i < markerStations.length; i++) {
        print("------------------shoplist-------------------------");
        print(markerStations.toString());

        MarkerId _markerId = MarkerId('marker_id_$i');
        // Future.delayed(Duration(milliseconds: 500), () {

        Marker _marker = Marker(
            icon: pinLocationIcon!,
            markerId: _markerId,
            position: LatLng(
                double.parse(markerStations[i].latitude.toString()),
                double.parse(markerStations[i].longtitude.toString())),
            draggable: false,
            onTap: () {
              shopController.addToSavedStations(stations,"",i);

            });
        markerData[_markerId] = _marker;
        //
        // });
      }
      if(mounted){
        setState(() {
          markers=controller.markers.value; //for default marker

          markers = markerData;
        });
      }

    }else{
      if(mounted){
        setState(() {
          markers=controller.markers.value; //for default marker
        });
      }
    }
  }

  Future<void> getBrands(int idBrandCategories, int limit, int offset) async {
    //shop = shopController.defaultShop.value;

    if (bController.homeBrandsList.length > 0 && idBrandCategories == -1)
       bController.homeBrandsList.addAll(brandList);

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
        bController.homeBrandsList.value = brandList;
        bController.homeBrandsList.refresh();
      }
    }

    setState(() {

    });
    getDefaultStations(latitude, longitude,mArraylistBrandIds);

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
      double.parse(latitude.toStringAsFixed(7)),
      double.parse(longitude.toStringAsFixed(7)),
      currentLat,
      currentLong,

    );

    double distanceInKiloMeters = _distanceInMeters / 1000;
    double roundDistanceInKM = double.parse((distanceInKiloMeters).toStringAsFixed(2));
    return roundDistanceInKM;


  }

  Future<void> getDefaultStations(double currentLat,double curentLong, List<int> mArraylistBrandIds) async {
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
        formattedBrandIds, 10);

    if (data['success']) {
      for (int i = 0; i < data['data'].length; i++) {
        Map<String, dynamic> item = data['data'][i];

        int id = int.parse(item['id'].toString());

        int index = stations.indexWhere((element) => element.id == id);

        if (index == -1) {
          double distanceInKms=await _getGeoLocationPosition(double.parse(item['latitude'].toString()),double.parse(item['longtitude'].toString()),currentLat,curentLong);
          if(distanceInKms<=10){
            setState(() {
              flagNoDataAvailable=true;
              stations.add(
                  Shop(
                      isDefault: true,
                      name: item['language']['name'],
                      description: item['language']['description'],
                      logoUrl:item['logo_url'],
                      id: item['id'],
                      backImageUrl: item['backimage_url'],
                      tax:item['tax'],
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

            });

          }
          else if(stations.length<=0){
            setState(() {
              flagNoDataAvailable=true;

            });
          }
        }

        print("stations:---"+shopController.shopList.toString());
      }
      _setMarker(stations);
    }
  }

  Widget loading() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CategoryProductItemShadow(),
            // CategoryProductItemShadow()
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = AppBar().preferredSize.height;
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushReplacement(context, MaterialPageRoute(builder:
          (context)=>LocationPage()));
          return false;
        },
        child:Scaffold(
          appBar:  Platform.isAndroid
            ?
          PreferredSize(
              preferredSize: Size(1.sw, 25.0),
              child: AppBarCustom(
                title: "",
                hasBack: true,

              ))
          :
              null,
        backgroundColor: Get.isDarkMode
            ? Color.fromRGBO(19, 20, 21, 1)
            : Color.fromRGBO(243, 243, 240, 1),
        body: SingleChildScrollView(
          child: Obx(() => Container(
                width: 1.sw,
                height: 1.sh,
                child: Stack(
                  children: <Widget>[
                    if (loadGoogleMap)
                      SizedBox(
                        width: 1.sw,
                        height: 2.sh,
                        child: GoogleMap(
                          mapType: MapType.normal,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: true,

                          markers: Set<Marker>.of(markers.values),
                          initialCameraPosition: CameraPosition(
                            target: LatLng(latitude, longitude),
                            zoom: 12.4746,
                          ),
                          //  _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            controller.setMapStyle(json.encode(Get.isDarkMode
                                ? MAP_DARK_THEME
                                : MAP_LIGHT_THEME));
                            _controller.complete(controller);
                          },
                        ),
                      ),
                    Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 1.sw,
                          height: 400,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: Get.isDarkMode
                                  ? const Color.fromRGBO(37, 48, 63, 1)
                                  : Colors.white,
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                    color: Color.fromRGBO(153, 153, 153, 0.2),
                                    offset: Offset(0, 4),
                                    blurRadius: 70,
                                    spreadRadius: 0)
                              ]
                          ),
                          child: Column(
                            children: <Widget>[
                              // Container(
                              //   width: 60,
                              //   height: 5,
                              //   margin: EdgeInsets.only(top: 10, bottom: 13),
                              //   decoration: BoxDecoration(
                              //       borderRadius: BorderRadius.circular(3),
                              //       color: Get.isDarkMode
                              //           ? Colors.white
                              //           : Color.fromRGBO(175, 175, 175, 1)),
                              // ),
                              Container(
                                height: 50,
                                width: 1.sw,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 1,
                                            color: Get.isDarkMode
                                                ? const Color.fromRGBO(
                                                    130, 139, 150, 0.14)
                                                : const Color.fromRGBO(
                                                    136, 136, 126, 0.14)))),
                                child: Center(
                                  child: TextField(
                                    controller: TextEditingController(
                                        text:
                                            shopController.addressController.searchText.value)
                                      ..selection = TextSelection.fromPosition(
                                        TextPosition(
                                            offset: shopController.addressController.searchText.value.length),
                                      ),
                                    textAlignVertical: TextAlignVertical.center,
                                    onChanged: (text) => shopController.addressController.onChangeAddressSearchText(text),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Search".tr,
                                        prefixIcon: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            const IconData(0xf0cd,
                                                fontFamily: 'MIcon'),
                                            size: 18.sp,
                                            color: Get.isDarkMode
                                                ? const Color.fromRGBO(
                                                    130, 139, 150, 1)
                                                : const Color.fromRGBO(
                                                    136, 136, 126, 1),
                                          ),
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () => shopController
                                              .addressController
                                              .onChangeAddressSearchText(""),
                                          icon: Icon(
                                            const IconData(0xeb99,
                                                fontFamily: 'MIcon'),
                                            size: 20.sp,
                                            color: Get.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        hintStyle: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            letterSpacing: -0.5,
                                            color: Get.isDarkMode
                                                ? const Color.fromRGBO(
                                                    130, 139, 150, 1)
                                                : const Color.fromRGBO(
                                                    136, 136, 126, 0.14))),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                          height: 34,
                                          width: 0.9.sw,
                                          child:brandList.isNotEmpty
                                                      ? ListView.builder(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              brandList.length,
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          itemBuilder:
                                                              (context, index) {
                                                            // bController
                                                            //         .brandProductsList = products;
                                                            Brand product =
                                                                brandList[index];
                                                            print(product
                                                                .toString());
                                                            bController.allBrands.addAll(brandList);
                                                            allBrandList.addAll(brandList);
                                                            if(flagStart==true)
                                                              {
                                                                allBrandList[0].isClicked=true;
                                                                bController.allBrands[0].isClicked=true;
                                                              }


                                                            return
                                                                InkWell(
                                                                    child:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              20),
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              8),
                                                                      height:
                                                                          34,
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration: BoxDecoration(
                                                                          color:
                                                                          allBrandList[index].isClicked==true

                                                                              ?
                                                                          const Color.fromRGBO(69, 165, 36, 1)
                                                                              : Get.isDarkMode
                                                                                  ? const Color.fromRGBO(26, 34, 44, 1)
                                                                                  : const Color.fromRGBO(233, 233, 230, 1),
                                                                          borderRadius: BorderRadius.circular(40)),
                                                                      child:
                                                                          // call api for brands
                                                                          Text(
                                                                            brandList[index]
                                                                            .name
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontFamily: 'Inter',
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 14.sp,
                                                                            letterSpacing: -0.5,
                                                                            color:
                                                                            allBrandList[index].isClicked==true
                                                                                ? Colors.white
                                                                                : Get.isDarkMode
                                                                                    ? Colors.white
                                                                                    : const Color.fromRGBO(0, 0, 0, 1)),
                                                                      ),
                                                                    ),
                                                                    onTap: () {
                                                                      stations=[];
                                                                      tabIndex.value = index;
                                                                      setState(() {
                                                                        flagNoDataAvailable=false;
                                                                        stations=[];
                                                                          if(allBrandList[index].isClicked!=true){
                                                                            allBrandList[index].isClicked=true;
                                                                            id = product.id!;
                                                                            mArraylistBrandIds.add(id);
                                                                          }else {
                                                                            // if(tabIndex.value!=0){ //used to have selected first index
                                                                            flagStart=false;
                                                                              allBrandList[index].isClicked=false;

                                                                              mArraylistBrandIds.removeAt(index);
                                                                            // }

                                                                          }
                                                                          getDefaultStations(latitude, longitude,mArraylistBrandIds);
                                                                          });

                                                                     });
                                                          },
                                                        )
                                                      :
                                               Container()
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                height: 250,
                                width: 1.sw,
                                child:
                                         stations.isNotEmpty
                                            ? ListView.builder(
                                                // shrinkWrap: true,
                                                // physics: NeverScrollableScrollPhysics(),
                                                itemCount: stations.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                itemBuilder: (context, index) {
                                                  // _getGeoLocationPosition(stations[index].latitude,stations[index]
                                                  //     .longtitude);
                                                  return ShopLocationItem(
                                                    onTap: () async {
                                                      print(
                                                          stations.toString());
                                                      // Map<String, dynamic>
                                                      //     shop = shopController
                                                      //         .shopList[index];
                                                      print(
                                                          "------------------shoplist-------------------------");
                                                      // print(controller.shopList.toString());
                                                      final GoogleMapController?
                                                          mapController =
                                                          await _controller
                                                              .future;
                                                      try {
                                                        mapController!
                                                            .animateCamera(
                                                                CameraUpdate
                                                                    .newCameraPosition(
                                                          CameraPosition(
                                                            bearing: 0,
                                                            target: LatLng(
                                                                double.parse(stations[index].latitude.toString()),
                                                                double.parse(stations[index].longtitude
                                                                    .toString())),
                                                            zoom: 17.0,
                                                          ),
                                                        ));

                                                        // shopController.addToSavedShop(
                                                        //         shop,stations[index].distance.toString());
                                                        shopController.addToSavedStations(stations,stations[index].distance.toString(),index);

                                                      } catch (e) {
                                                        print(e);
                                                      }
                                                    },
                                                    // distanceInMeteres:  _getGeoLocationPosition(stations[index].latitude,stations[index]
                                                    //     .longtitude),
                                                    distanceInKm: stations[index].distance,
                                                    currentLat:latitude,
                                                    currentLong:longitude,
                                                    name: stations[index].name,
                                                    address:
                                                        stations[index].address,
                                                    // rating: stations[index]
                                                    //     .rating
                                                    //     .toString(), //shop['rating'].toString(),
                                                    backImage: stations[index]
                                                        .backImageUrl,
                                                    logoImage:
                                                        stations[index].logoUrl,
                                                    availablePorts:
                                                        stations[index]
                                                            .availablePorts
                                                            .toString(),
                                                    lat: stations[index]
                                                        .latitude,
                                                    long: stations[index]
                                                        .longtitude,
                                                  );
                                                })
                                           :
                                         flagNoDataAvailable==false?
                                       Center(
                                      child: SizedBox(
                                        height: 20.0,
                                        width: 20.0,
                                        child: CircularProgressIndicator(),
                                        // padding: EdgeInsets.symmetric(
                                        //     horizontal: 15, vertical: 10),
                                        // child: loading(),
                                      ),

                                )
                                             :
                                         Center(
                                           child: SizedBox(
                                             height: 20.0,
                                             child: Text("No Data Available",textAlign:TextAlign.center,style: TextStyle(fontFamily: 'Sofia pro',
                                             fontSize: 16.0,fontWeight: FontWeight.w600),),
                                             // padding: EdgeInsets.symmetric(
                                             //     horizontal: 15, vertical: 10),
                                             // child: loading(),
                                           ),
                              )),
                            ],
                          ),
                        ))
                  ],
                ),
              )),
        )));
  }



// Added by Aditi on 22-3-22
/*showBrands() async {
    // https://{{demo_url}}/api/m/brand/get
    //
    // id_shop:4
    // id_brand_category:0
    // limit:5
    // offset:0
    String url = "$GLOBAL_URL/brand/get";

    try {
      var parameter = {
        'id_shop': 4,
        'id_brand_category':0,
        'limit':5,
        'offset':0
      };

      Response response =
          await post(Uri.parse(url),  body: parameter)
          .timeout(Duration(seconds: timeOut));

      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        // String msg = getdata["message"];

        if (!error) {
          print(getdata.toString());

          tabs.clear();
          Data data = getdata["data"];
          for(var i in data.name)
            {
              data[i].
            }
          var brand = data["name"];
          print("redeemList $brand");
          var tempList = (tabs as List)
              .map((goldRedeemList) =>
          new BrandsModel.fromJson(data).toList();

          tranList.addAll(tempList);

          //offset = offset + perPage;
        }
      }

    } on TimeoutException catch (_) {
     // setSnackbar(getTranslated(context, 'somethingMSg')!);

    }
  }*/
}
