import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '/config/global_config.dart';

class ShopLocationItem extends StatefulWidget {
  final String? name;
  final String? address;
  final String? backImage;
  final String? logoImage;
  final String? rating;
  var availablePorts;
  var lat;
  var long;
  var currentLat;
  var currentLong;
  var distanceInKm;
  final Function()? onTap;

  late Position _currentPosition;

  ShopLocationItem({this.name,
    this.address,
    this.rating,
    this.backImage,
    this.logoImage,
    this.availablePorts,
    this.lat,
    this.long,
    this.onTap,
    this.distanceInKm,
  this.currentLat,
  this.currentLong});



  ShopLocationItemState createState()=>ShopLocationItemState();
}
class ShopLocationItemState extends State<ShopLocationItem>{
  var _distanceInMeters;
  var distanceInKiloMeters;
  bool flagDataVisible=false;

  @override
  void initState() {
    super.initState();
   // _getGeoLocationPosition();
  }

  void _launchMap(address, {latitude, longitude}) {
    if (latitude != null && longitude != null) {
      MapsLauncher.launchCoordinates(latitude!, longitude!);
      return;
    }
    MapsLauncher.launchQuery(address);
  }

  Future<double> getDistanceFromLatLong(String? lat, String? long) async {
    _getGeoLocationPosition();
    var _distanceInMeters = await Geolocator.distanceBetween(lat as double,
        long as double,widget. _currentPosition.latitude, widget._currentPosition.longitude);
    return _distanceInMeters;
  }

  Future<void> _getGeoLocationPosition() async {
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
      setState(() {
        _distanceInMeters = Geolocator.distanceBetween(
            widget.lat as double,
            widget.long as double,
            widget.currentLat as double,
            widget.currentLong as double,
            // widget._currentPosition.latitude,
            // widget._currentPosition.longitude
        );

        distanceInKiloMeters = _distanceInMeters / 1000;
        // double roundDistanceInKM = double.parse((distanceInKiloMeters).toStringAsFixed(2));
        // if(distanceInKiloMeters<=10){
        //   flagDataVisible=true;
        // }else{
        //   flagDataVisible=false;
        // }
      // });

      //return _distanceInMeters;
    });
    // return _distanceInMeters;
  }

  @override
  Widget build(BuildContext context) {
    // if(flagDataVisible==true)
    //   {
        return InkWell(
          onTap:widget.onTap,
          child: Container(
            width: 270,
            height: 224,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Get.isDarkMode
                    ? const Color.fromRGBO(26, 34, 44, 1)
                    : const Color.fromRGBO(243, 243, 243, 1)),
            child: Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: 270,
                    height: 100,
                    imageUrl: "$GLOBAL_IMAGE_URL"+widget.backImage.toString(),
                    placeholder: (context, url) => Container(
                      alignment: Alignment.center,
                      child: Icon(
                        const IconData(0xee4b, fontFamily: 'MIcon'),
                        color: const Color.fromRGBO(233, 233, 230, 1),
                        size: 20.sp,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Positioned(
                  left: 14,
                  top: 76,
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        fit: BoxFit.fitWidth,
                        width: 38,
                        height: 38,
                        imageUrl: "$GLOBAL_IMAGE_URL"+widget.logoImage.toString(),
                        placeholder: (context, url) => Container(
                          alignment: Alignment.center,
                          child: Icon(
                            const IconData(0xee4b, fontFamily: 'MIcon'),
                            color: Color.fromRGBO(233, 233, 230, 1),
                            size: 20.sp,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    left: 0,
                    top: 95,
                    child: Container(
                      width: 270,
                      padding: const EdgeInsets.only(
                          left: 14, right: 14, top: 25, bottom: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                width: 200,
                                child: Text(
                                  widget.name.toString(),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14.sp,
                                      letterSpacing: -0.4,
                                      color: Get.isDarkMode
                                          ? Colors.white
                                          : const Color.fromRGBO(0, 0, 0, 1)),
                                ),
                              ),
                              /* ratings hidden tempararily as feedback screen not done*/
                              // Icon(
                              //   const IconData(0xf18e, fontFamily: 'MIcon'),
                              //   size: 15.sp,
                              //   color: const Color.fromRGBO(255, 161, 0, 1),
                              // ),
                              // Text(
                              //   "$rating",
                              //   style: TextStyle(
                              //       fontFamily: 'Inter',
                              //       fontWeight: FontWeight.w500,
                              //       fontSize: 15.sp,
                              //       letterSpacing: -0.4,
                              //       color: Get.isDarkMode
                              //           ? Colors.white
                              //           : Color.fromRGBO(0, 0, 0, 1)),
                              // )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                const IconData(0xef09, fontFamily: 'MIcon'),
                                size: 20.sp,
                                color: Get.isDarkMode
                                    ? const Color.fromRGBO(130, 139, 150, 1)
                                    : const Color.fromRGBO(136, 136, 126, 1),
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 200,
                                child: Text(
                                  widget.address.toString(),
                                  maxLines: 4,
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12.sp,
                                      letterSpacing: -0.4,
                                      color: Get.isDarkMode
                                          ? Color.fromRGBO(130, 139, 150, 1)
                                          : Color.fromRGBO(136, 136, 126, 1)),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                const IconData(0xeedd, fontFamily: 'MaterialIcons'),
                                size: 16.sp,
                                color: Get.isDarkMode
                                    ? const Color.fromRGBO(130, 139, 150, 1)
                                    : const Color.fromRGBO(100, 200, 100, 1),
                              ),
                              // const SizedBox(width: 5),
                              Expanded(child: Text(
                                //"4/5 Available",
                                widget.availablePorts.toString(),
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp,
                                    letterSpacing: -0.4,
                                    color: Get.isDarkMode
                                        ? const Color.fromRGBO(130, 139, 150, 1)
                                        : const Color.fromRGBO(100, 200, 100, 1)),
                              )),
                              const SizedBox(width: 25),
                              Expanded(child: InkWell(
                                onTap: () {
                                  _launchMap(widget.address);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      //getDistanceFromLatLong(lat, long).toString(),
                                      // _getGeoLocationPosition().toString(),
                                      // "45 Km ",
                                      // distanceInKiloMeters!=null?distanceInKiloMeters.toStringAsFixed(2).toString()+" KM ":"",
                                      widget.distanceInKm!=null?widget.distanceInKm.toStringAsFixed(2).toString()+" KM ":"",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                          letterSpacing: -0.4,
                                          color: Get.isDarkMode
                                              ? const Color.fromRGBO(
                                              130, 139, 150, 1)
                                              : const Color.fromRGBO(
                                              136, 136, 126, 1)),
                                    ),
                                    // const SizedBox(width: 5),
                                    Expanded(child:Image.asset(
                                        "lib/assets/images/Getdirection.png",
                                        height: 25,
                                        fit: BoxFit.contain,
                                        width: 25)),
                                  ],
                                ),
                              ))
                            ],
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        );
    //   }else{
    //   return Container();
    // }

  }


}
