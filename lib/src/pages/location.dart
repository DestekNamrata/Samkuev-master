import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:samku/src/components/empty.dart';
import 'package:samku/src/controllers/brands_controller.dart';
import 'package:samku/src/controllers/category_controller.dart';
import 'package:samku/src/controllers/shop_controller.dart';
import 'package:samku/src/models/shop.dart';
import 'package:samku/src/models/user.dart';
import 'package:samku/src/pages/chargedetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart' as GooglePlace;
import 'package:samku/src/requests/brands_prod_req_new.dart';

import '/config/global_config.dart';
import '/src/components/location_search_item.dart';
import '/src/controllers/address_controller.dart';
import '/src/themes/map_dark_theme.dart';
import '/src/themes/map_light_theme.dart';

// class LocationPage extends GetView<AddressController> {
class LocationPage extends StatefulWidget {

  LocationPageState createState()=>LocationPageState();

}
class LocationPageState extends State<LocationPage>{

  final ShopController shopcontroller = Get.put(ShopController());
  final BrandsController bController = Get.put(BrandsController());
  final AddressController controller = Get.put(AddressController());
  List<Shop> stations = [];
  Map<MarkerId, Marker> markers = {};
  BitmapDescriptor? pinLocationIcon;
  Users? user;
  bool clickPredictions=false;


  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(MAP_DEFAULT_LATITUDE, MAP_DEFAULT_LONGITUDE),
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    controller.mapController = Completer();
    user = controller.authController.user.value;
    controller.currentLocation();
    setCustomMapPin();
    getDefaultStations(controller.latitude.value,controller.longitude.value);

  }

  @override
 void dispose(){
    super.dispose();
    controller.dispose();
  }

  Future<void> getDefaultStations(double currentLat,double curentLong) async {
    Map<String, dynamic> data =
    await /*brandsProductsRequest*/ brandsProductsReqNew(
        "", 10);

    if (data['success']) {
      for (int i = 0; i < data['data'].length; i++) {
        Map<String, dynamic> item = data['data'][i];

        int id = int.parse(item['id'].toString());

        int index = stations.indexWhere((element) => element.id == id);

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
          }
        }

        print("stations:---"+stations.toString());
      }


      _setMarker(stations);


    }


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

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(),
        'lib/assets/images/Chargestation.png');
  }

  void _setMarker(List<Shop> stations) {
    Map<MarkerId, Marker> markerData = {};

    if (stations.length > 0) {
        // ignore: curly_braces_in_flow_control_structures
        for (int i = 0; i < stations.length; i++) {
          print("------------------shoplist-------------------------");
          print(stations.toString());

          MarkerId _markerId = MarkerId('marker_id_$i');
          // Future.delayed(Duration(milliseconds: 500), () {

              Marker _marker = Marker(
                  icon: pinLocationIcon!,
                  markerId: _markerId,
                  position: LatLng(
                      double.parse(stations[i].latitude.toString()),
                      double.parse(stations[i].longtitude.toString())),
                  draggable: false,
                  onTap: () {
                    shopcontroller.addToSavedStations(stations,"",i);

                  });
              markerData[_markerId] = _marker;
          //
          // });
        }
         if(mounted){
           setState(() {
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


  Future<bool> _exitApp(BuildContext context) async{
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: new Text('Do you want to exit this application?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              FlatButton(
                // onPressed: () => Navigator.of(context).pop(true),
                onPressed: () => exit(0), //updated on 12/02/2021
                child: new Text('Yes'),
              ),
            ],
          );
        }) ??
        false;

  }



  @override
  Widget build(BuildContext context) {

    return WillPopScope(
        onWillPop: () => _exitApp(context),
        child:
      Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      body: Obx(() => Container(
            width: 1.sw,
            height: 1.sh,
            child: Stack(
              children: <Widget>[
                // FutureBuilder<List<Shop>>(
                //   future: bController.getDefaultStations(
                //        controller.latitude.value,controller.longitude.value),
                //   builder: (context, snapshot) {
                //     if (snapshot.hasData &&
                //         !bController.load.value) {
                //       List<Widget> row = [];
                //       if (snapshot.hasData) {
                //         stations = snapshot.data ?? [];
                //          //to set marker
                //
                //         print("stations:-" +
                //             snapshot.data.toString());

                        Container(
                            width: 1.sw,
                            height: 1.sh,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              onTap: (LatLng data) {
                                controller.moveToCoords(data.latitude, data.longitude);
                                // controller.getPlaceName(data.latitude, data.longitude);
                              },
                              myLocationEnabled: true,
                              myLocationButtonEnabled: false,
                              markers:Set<Marker>.of(markers.values) ,
                              padding: EdgeInsets.only(top: 600, right: 0),
                              zoomControlsEnabled: false,
                              // initialCameraPosition: _kGooglePlex,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(controller.latitude.value, controller.longitude.value),
                                zoom: 12,
                              ),
                              onMapCreated: (GoogleMapController mapcontroller) {
                                mapcontroller.setMapStyle(json.encode(
                                    Get.isDarkMode ? MAP_DARK_THEME : MAP_LIGHT_THEME));
                                if (!controller.mapController!.isCompleted)
                                  controller.mapController!.complete(mapcontroller);
                              },
                            ),
                          ),


                    //   }
                    //
                    // } else if (snapshot.hasError) {
                    //   return Text("${snapshot.error}");
                    // }
                   if(markers.isEmpty)
                     Center(
                      child: SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(),
                        // padding: EdgeInsets.symmetric(
                        //     horizontal: 15, vertical: 10),
                        // child: loading(),
                      ),
                    ),

                // Container(
                //   width: 1.sw,
                //   height: 1.sh,
                //   child: GoogleMap(
                //     mapType: MapType.normal,
                //     onTap: (LatLng data) {
                //       controller.moveToCoords(data.latitude, data.longitude);
                //       // controller.getPlaceName(data.latitude, data.longitude);
                //     },
                //     myLocationEnabled: true,
                //     myLocationButtonEnabled: false,
                //     markers: Set<Marker>.of(controller.markers.values),
                //     padding: EdgeInsets.only(top: 600, right: 0),
                //     zoomControlsEnabled: false,
                //     initialCameraPosition: _kGooglePlex,
                //     // initialCameraPosition: CameraPosition(
                //     //   target: LatLng(controller.latitude, controller.longitude),
                //     //   zoom: 14,
                //     // ),
                //     onMapCreated: (GoogleMapController mapcontroller) {
                //       mapcontroller.setMapStyle(json.encode(
                //           Get.isDarkMode ? MAP_DARK_THEME : MAP_LIGHT_THEME));
                //       if (!controller.mapController!.isCompleted)
                //         controller.mapController!.complete(mapcontroller);
                //     },
                //   ),
                // ),
                Positioned(
                    top: 53,
                    left: 10,
                    right: 25,
                    child: Column(
                      children: <Widget>[
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  border: Border.all(
                                      width: 3,
                                      color: Get.isDarkMode
                                          ? Color.fromRGBO(130, 139, 150, 0.1)
                                          : Colors.green),
                                  borderRadius: BorderRadius.circular(23)),
                              child: InkWell(
                                  onTap: () {
                                    Get.toNamed("/profile");
                                  },
                                  child: user!.imageUrl!.length > 4
                                      ?
                                  ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.fill,
                                            imageUrl:
                                                "$GLOBAL_IMAGE_URL${user!.imageUrl}",
                                            placeholder: (context, url) =>
                                                Container(
                                              width: 40,
                                              height: 40,
                                              alignment: Alignment.center,
                                              child: Icon(
                                                const IconData(0xee4b,
                                                    fontFamily: 'MIcon'),
                                                color: Colors.white,
                                                size: 20.sp,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ))
                                      : Icon(
                                          const IconData(0xf25c,
                                              fontFamily: 'MIcon'),
                                          color: Get.isDarkMode
                                              ? Color.fromRGBO(255, 255, 255, 1)
                                              : Color.fromRGBO(0, 0, 0, 1),
                                          size: 20,
                                        )),
                            ),
                            Expanded(
                                child:
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              width: 1.sw - 100,
                              decoration: BoxDecoration(
                                  boxShadow: const <BoxShadow>[
                                    BoxShadow(
                                        color:
                                            Color.fromRGBO(169, 169, 150, 0.13),
                                        offset: Offset(0, 2),
                                        blurRadius: 2,
                                        spreadRadius: 0)
                                  ],
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(37, 48, 63, 1)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(25)),
                              child: TextField(
                                controller: TextEditingController(
                                    text: controller.searchText.value)
                                  ..selection = TextSelection.fromPosition(
                                    TextPosition(
                                        offset:
                                            controller.searchText.value.length),
                                  ),
                                textAlignVertical: TextAlignVertical.center,
                                onChanged: (text) {
                                  controller.onChangeAddressSearchText(text);

                                },
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16.sp,
                                    letterSpacing: -0.4,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      const IconData(0xf0d1,
                                          fontFamily: 'MIcon'),
                                      size: 22.sp,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () => controller
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
                                ),
                              ),
                            )
                            ),

                            // scanner
    //                         Container(
    //                           // width: 0.1.sw,
    //                           // height: 0.045.sh,
    //                           alignment: Alignment.center,
    //                           margin: EdgeInsets.only(left: 8.0),
    //                           decoration: BoxDecoration(
    //                               color: Colors.green,
    //                               border: Border.all(
    //                                   width: 3,
    //                                   color: Get.isDarkMode
    //                                       ? Color.fromRGBO(130, 139, 150, 0.1)
    //                                       : Colors.green),
    //                               // borderRadius: BorderRadius.circular(50)
    //                           ),
    //                           child: InkWell(
    //                               onTap: () async{
    //                                 var qrdata = await FlutterBarcodeScanner.scanBarcode(
    //                                     "red", "Cancel", true, ScanMode.QR);
    //
    //                                 print('-------------------${qrdata.toString()}');
    //                                 // check when coming from cancel button=-1
    //                                 if(qrdata!="-1"){
    //                                   Future.delayed(Duration(milliseconds: 100),
    //                                           () {
    //                                         Get.to(
    //                                             ChargeingDetails(
    //                                               qrdata: int.parse(qrdata.trim()),
    //                                             ),
    //                                             arguments: [
    //                                               {},
    //                                             ]);
    //                                         // Do something
    //                                       });
    //                                 }else{
    //                                   Get.toNamed("/location");
    //                                 }
    //
    //                               },
    //                               child: Icon(Icons.qr_code_2_rounded,
    //                                 color: Colors.black,
    //                                 size: 35,
    //                               ),
    //                         ),
    // //                         Container(
    // //                           width: 0.05.sw,
    // //                           height: 0.045.sh,
    // //                           alignment: Alignment.center,
    // //                           margin: const EdgeInsets.only(right: 5, top: 0),
    // //                           decoration: BoxDecoration(
    // //                             color: Colors.green,
    // //                             border: Border.all(
    // //                                 width: 3,
    // //                                 color: Get.isDarkMode
    // //                                     ? Color.fromRGBO(130, 139, 150, 0.1)
    // //                                     : Colors.green),
    // //                             //borderRadius: BorderRadius.circular(50)
    // //                           ),
    // //                           child: InkWell(
    // //                             child:Icon(
    // //                               Icons.qr_code_2_rounded,
    // //                               color: Colors.black,
    // //                               size: 35,
    // //                             ),
    // //                             onTap: () async {
    // // // Get.toNamed("/profile");
    // //                               var qrdata =
    // //                                   await FlutterBarcodeScanner.scanBarcode(
    // //                                       "red", "Cancel", true, ScanMode.QR);
    // //
    // //                               print(
    // //                                   '-------------------${qrdata.toString()}');
    // //                               Future.delayed(Duration(milliseconds: 100),
    // //                                   () {
    // //                                 Get.to(
    // //                                     ChargeingDetails(
    // //                                       qrdata: int.parse(qrdata.trim()),
    // //                                     ),
    // //                                     arguments: [
    // //                                       {},
    // //                                     ]);
    // //                                 // Do something
    // //                               });
    // //                             },
    // //                             //      )
    // //                           ),
    //                         )
                          ],
                        ),
                        if (controller.isSearch.value)
                          Container(
                            margin: const EdgeInsets.only(top: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                      color:
                                          Color.fromRGBO(169, 169, 150, 0.13),
                                      offset: Offset(0, 2),
                                      blurRadius: 2,
                                      spreadRadius: 0)
                                ],
                                color: Get.isDarkMode
                                    ? Color.fromRGBO(37, 48, 63, 1)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: controller.predictions.map((element) {
                                int index =
                                    controller.predictions.indexOf(element);
                                GooglePlace.AutocompletePrediction prediction =
                                    element;

                                return LocationSearchItem(
                                  mainText:
                                      prediction.structuredFormatting!.mainText,
                                  address: prediction
                                      .structuredFormatting!.secondaryText,
                                  onClickRaw: (text)=>
                                      controller.getLatLngFromName(text).then((value){
                                        stations=[];
                                        getDefaultStations(controller.latitude.value, controller.longitude.value);
                                      }),

                                  onClickIcon: (text) =>
                                      controller.onChangeSearchText(text),
                                  isLast: index ==
                                      (controller.predictions.length - 1),
                                );
                              }).toList(),
                            ),
                          )
                      ],
                    )),
              ],
            ),
          )),
      floatingActionButton: TextButton(
        style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.all(0))),
        onPressed: controller.currentLocation,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 2,
                    spreadRadius: 0,
                    color: Color.fromRGBO(166, 166, 166, 0.25))
              ],
              borderRadius: BorderRadius.circular(30),
              color: Get.isDarkMode
                  ? Color.fromRGBO(37, 48, 63, 1)
                  : Colors.white),
          alignment: Alignment.center,
          child: Icon(
            const IconData(0xef88, fontFamily: 'MIcon'),
            color: Get.isDarkMode ? Colors.white : Colors.black,
            size: 32.sp,
          ),
        ),
      ),
      extendBody: true,

      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
        child:
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     // TextButton(
        //     //     style: ButtonStyle(
        //     //         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        //     //             EdgeInsets.all(0))),
        //     //     child: Container(
        //     //       // width: 1.sw - 30,
        //     //       width: 1.sw - 90,
        //     //       height: 60,
        //     //       alignment: Alignment.center,
        //     //       child: Text(
        //     //         "Continue".tr,
        //     //         style: TextStyle(
        //     //             fontFamily: 'Inter',
        //     //             fontWeight: FontWeight.w600,
        //     //             fontSize: 18.sp,
        //     //             color: Color.fromRGBO(255, 255, 255, 1)),
        //     //       ),
        //     //       decoration: BoxDecoration(
        //     //           color: Color.fromRGBO(69, 165, 36, 1),
        //     //           borderRadius: BorderRadius.circular(30)),
        //     //     ),
        //     //     onPressed: () {
        //     //       SystemChannels.textInput.invokeMethod('TextInput.hide');
        //     //
        //     //       if(controller.searchText.value.isNotEmpty) {
        //     //         Get.toNamed("/shopsLocation");
        //     //       }else{
        //     //         Fluttertoast.showToast(msg: "Please select location");
        //     //       }
        //     //     }),
        //
        //          Expanded(
        //              child: Container(
        //            width: 60.0,
        //            height: 60.0,
        //            alignment: Alignment.bottomCenter,
        //            margin: EdgeInsets.only(left: 8.0),
        //            decoration: BoxDecoration(
        //              color: Colors.green,
        //              border: Border.all(
        //                  width: 3,
        //                  color: Get.isDarkMode
        //                      ? Color.fromRGBO(130, 139, 150, 0.1)
        //                      : Colors.green),
        //              // borderRadius: BorderRadius.circular(50)
        //            ),
        //            child: InkWell(
        //              onTap: () async{
        //                var qrdata = await FlutterBarcodeScanner.scanBarcode(
        //                    "red", "Cancel", true, ScanMode.QR);
        //
        //                print('-------------------${qrdata.toString()}');
        //                // check when coming from cancel button=-1
        //                if(qrdata!="-1"){
        //                  Future.delayed(Duration(milliseconds: 100),
        //                          () {
        //                        Get.to(
        //                            ChargeingDetails(
        //                              qrdata: int.parse(qrdata.trim()),
        //                            ),
        //                            arguments: [
        //                              {},
        //                            ]);
        //                        // Do something
        //                      });
        //                }else{
        //                  Get.toNamed("/location");
        //                }
        //
        //              },
        //              child: Icon(Icons.qr_code_2_rounded,
        //                color: Colors.black,
        //                size: 45,
        //              ),
        //            ),
        //            //                         Container(
        //            //                           width: 0.05.sw,
        //            //                           height: 0.045.sh,
        //            //                           alignment: Alignment.center,
        //            //                           margin: const EdgeInsets.only(right: 5, top: 0),
        //            //                           decoration: BoxDecoration(
        //            //                             color: Colors.green,
        //            //                             border: Border.all(
        //            //                                 width: 3,
        //            //                                 color: Get.isDarkMode
        //            //                                     ? Color.fromRGBO(130, 139, 150, 0.1)
        //            //                                     : Colors.green),
        //            //                             //borderRadius: BorderRadius.circular(50)
        //            //                           ),
        //            //                           child: InkWell(
        //            //                             child:Icon(
        //            //                               Icons.qr_code_2_rounded,
        //            //                               color: Colors.black,
        //            //                               size: 35,
        //            //                             ),
        //            //                             onTap: () async {
        //            // // Get.toNamed("/profile");
        //            //                               var qrdata =
        //            //                                   await FlutterBarcodeScanner.scanBarcode(
        //            //                                       "red", "Cancel", true, ScanMode.QR);
        //            //
        //            //                               print(
        //            //                                   '-------------------${qrdata.toString()}');
        //            //                               Future.delayed(Duration(milliseconds: 100),
        //            //                                   () {
        //            //                                 Get.to(
        //            //                                     ChargeingDetails(
        //            //                                       qrdata: int.parse(qrdata.trim()),
        //            //                                     ),
        //            //                                     arguments: [
        //            //                                       {},
        //            //                                     ]);
        //            //                                 // Do something
        //            //                               });
        //            //                             },
        //            //                             //      )
        //            //                           ),
        //          )),
        //
        //
        //
        //       Container(
        //           child:Icon(Icons.eighteen_mp))
        //
        //
        //   ],
        // ),
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 60.0,
                height: 60.0,
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 8.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(
                      width: 3,
                      color: Get.isDarkMode
                          ? Color.fromRGBO(130, 139, 150, 0.1)
                          : Colors.green),
                  // borderRadius: BorderRadius.circular(50)
                ),
                child: InkWell(
                  onTap: () async{
                    var qrdata = await FlutterBarcodeScanner.scanBarcode(
                        "red", "Cancel", true, ScanMode.QR);

                    print('-------------------${qrdata.toString()}');
                    // check when coming from cancel button=-1
                    if(qrdata!="-1"){
                      Future.delayed(Duration(milliseconds: 100),
                              () {
                            Get.to(
                                ChargeingDetails(
                                  qrdata: int.parse(qrdata.trim()),
                                ),
                                arguments: [
                                  {},
                                ]);
                            // Do something
                          });
                    }else{
                      Get.toNamed("/location");
                    }

                  },
                  child: Icon(Icons.qr_code_2_rounded,
                    color: Colors.black,
                    size: 45,
                  ),
                ),
                //                         Container(
                //                           width: 0.05.sw,
                //                           height: 0.045.sh,
                //                           alignment: Alignment.center,
                //                           margin: const EdgeInsets.only(right: 5, top: 0),
                //                           decoration: BoxDecoration(
                //                             color: Colors.green,
                //                             border: Border.all(
                //                                 width: 3,
                //                                 color: Get.isDarkMode
                //                                     ? Color.fromRGBO(130, 139, 150, 0.1)
                //                                     : Colors.green),
                //                             //borderRadius: BorderRadius.circular(50)
                //                           ),
                //                           child: InkWell(
                //                             child:Icon(
                //                               Icons.qr_code_2_rounded,
                //                               color: Colors.black,
                //                               size: 35,
                //                             ),
                //                             onTap: () async {
                // // Get.toNamed("/profile");
                //                               var qrdata =
                //                                   await FlutterBarcodeScanner.scanBarcode(
                //                                       "red", "Cancel", true, ScanMode.QR);
                //
                //                               print(
                //                                   '-------------------${qrdata.toString()}');
                //                               Future.delayed(Duration(milliseconds: 100),
                //                                   () {
                //                                 Get.to(
                //                                     ChargeingDetails(
                //                                       qrdata: int.parse(qrdata.trim()),
                //                                     ),
                //                                     arguments: [
                //                                       {},
                //                                     ]);
                //                                 // Do something
                //                               });
                //                             },
                //                             //      )
                //                           ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                          child:
                TextButton(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.all(0))),
                        child: Container(
                          // width: 1.sw - 30,
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          child:
                          Icon(Icons.arrow_forward,color: Colors.white,size: 25.0,),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(69, 165, 36, 1),
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                          SystemChannels.textInput.invokeMethod('TextInput.hide');

                          if(controller.searchText.value.isNotEmpty) {
                            Get.toNamed("/shopsLocation");
                          }else{
                            Fluttertoast.showToast(msg: "Please select location");
                          }
                        }),
              ),
            )
          ],
        ),
      ),
    ));
  }
}


