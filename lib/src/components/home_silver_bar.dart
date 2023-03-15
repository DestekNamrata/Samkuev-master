import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:samku/src/pages/chargedetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:maps_launcher/maps_launcher.dart';

import '/config/global_config.dart';
import '/src/controllers/notification_controller.dart';
import '/src/controllers/shop_controller.dart';
import '/src/models/shop.dart';

class HomeSilverBar extends StatelessWidget {
  final ShopController shopController = Get.put(ShopController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  void _launchMap(address, {latitude, longitude}) {
    if (latitude != null && longitude != null) {
      MapsLauncher.launchCoordinates(latitude!, longitude!);
      return;
    }
    MapsLauncher.launchQuery(address);
  }

  @override
  Widget build(BuildContext context) {
    Shop? shop = shopController.defaultShop.value;
    return SliverAppBar(
      expandedHeight: 320,
      floating: false,
      automaticallyImplyLeading: false,
      pinned: true,
      shadowColor: Color.fromRGBO(169, 169, 150, 0.13),
      backgroundColor:
          Get.isDarkMode ? Color.fromRGBO(23, 27, 32, 0.13) : Colors.white,
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        double height = constraints.biggest.height - 100;

        return FlexibleSpaceBar(
          centerTitle: true,
          background: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: "$GLOBAL_IMAGE_URL${shop!.backImageUrl}",
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
          titlePadding: EdgeInsets.zero,
          title: AnimatedOpacity(
            duration: Duration(milliseconds: 300),
            opacity: 1.0,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: <
                Widget>[
              // Container(
              // margin: EdgeInsets.symmetric(horizontal: height > 0 ? 10 : 15),
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              // Row(
              //   children: <Widget>[
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(40),
              //   child: CachedNetworkImage(
              //     fit: BoxFit.cover,
              //     width: 44,
              //     height: 44,
              //     imageUrl: "$GLOBAL_IMAGE_URL${shop.logoUrl}",
              //     placeholder: (context, url) => Container(
              //       alignment: Alignment.center,
              //       child: Icon(
              //         const IconData(0xee4b, fontFamily: 'MIcon'),
              //         color: Color.fromRGBO(233, 233, 230, 1),
              //         size: 20.sp,
              //       ),
              //     ),
              //     errorWidget: (context, url, error) =>
              //         Icon(Icons.error),
              //   ),
              // ),
              // Container(
              //     width: 1.sw - 240,
              //     padding: EdgeInsets.only(left: 8),
              //     alignment: Alignment.centerLeft,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: <Widget>[
              // InkWell(
              //   onTap: () {
              //     Get.offAndToNamed("/store");
              //     shopController.defaultShop.value = null;
              //   },
              //   child: Row(
              //       mainAxisAlignment:
              //           MainAxisAlignment.start,
              //       crossAxisAlignment:
              //           CrossAxisAlignment.center,
              //       mainAxisSize: MainAxisSize.max,
              //       children: <Widget>[
              // Container(
              //   width: 1.sw - 275,
              //   child: Text(
              //     "${shop.name}",
              //     style: TextStyle(
              //         fontFamily: 'Inter',
              //         fontWeight: FontWeight.w600,
              //         letterSpacing: -1,
              //         fontSize: 16.sp,
              //         color: height > 0
              //             ? Colors.white
              //             : Get.isDarkMode
              //                 ? Color.fromRGBO(
              //                     255, 255, 255, 1)
              //                 : Color.fromRGBO(
              //                     0, 0, 0, 1)),
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(left: 8),
              //   alignment: Alignment.center,
              //   child: Icon(
              //     const IconData(0xea4e,
              //         fontFamily: "MIcon"),
              //     color: height > 0
              //         ? Colors.white
              //         : Get.isDarkMode
              //             ? Color.fromRGBO(
              //                 255, 255, 255, 1)
              //             : Color.fromRGBO(
              //                 0, 0, 0, 1),
              //     size: 16.sp,
              //   ),
              // )
              //       ]),
              // ),
              // Container(
              //   child: Row(
              //     children: <Widget>[
              //       SizedBox(
              //         width: 1.sw - 270,
              //         child: Text(
              //           "${"Working hours".tr} ${shop.openHours} — ${shop.closeHours}",
              //           softWrap: true,
              //           style: TextStyle(
              //               fontFamily: 'Inter',
              //               fontWeight: FontWeight.w500,
              //               letterSpacing: -0.4,
              //               fontSize: 10.sp,
              //               color: height > 0
              //                   ? Colors.white
              //                   : Get.isDarkMode
              //                       ? Color.fromRGBO(
              //                           255, 255, 255, 1)
              //                       : Color.fromRGBO(
              //                           0, 0, 0, 1)),
              //         ),
              //       ),
              //       Container(
              //         margin: EdgeInsets.only(left: 10),
              //         child: Icon(
              //           const IconData(0xee58,
              //               fontFamily: 'MIcon'),
              //           size: 12.sp,
              //           color: height > 0
              //               ? Colors.white
              //               : Get.isDarkMode
              //                   ? Color.fromRGBO(
              //                       255, 255, 255, 1)
              //                   : Color.fromRGBO(
              //                       0, 0, 0, 1),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              //   ],
              // )),
              //   ],
              // ),
              // Obx(() {
              //   return Container(
              //     height: 30,
              //     width: 30,
              //     child: Stack(
              //       children: <Widget>[
              //         TextButton(
              //             style: ButtonStyle(
              //                 padding: MaterialStateProperty.all<
              //                         EdgeInsetsGeometry>(
              //                     EdgeInsets.all(0))),
              //             onPressed: () =>
              //                 Get.toNamed("/notifications"),
              //             child: Icon(
              //               const IconData(0xef99, fontFamily: 'MIcon'),
              //               size: 18.sp,
              //               color: Get.isDarkMode
              //                   ? Color.fromRGBO(255, 255, 255, 1)
              //                   : Color.fromRGBO(136, 136, 126, 1),
              //             )),
              //         if (notificationController
              //                 .unreadedNotifications.value >
              //             0)
              //           Positioned(
              //               top: 0,
              //               right: 0,
              //               child: Container(
              //                 width: 15,
              //                 height: 15,
              //                 decoration: BoxDecoration(
              //                     borderRadius:
              //                         BorderRadius.circular(10),
              //                     color:
              //                         Color.fromRGBO(255, 184, 0, 1)),
              //                 alignment: Alignment.center,
              //                 child: Text(
              //                   "${notificationController.unreadedNotifications.value}",
              //                   style: TextStyle(
              //                       fontFamily: 'Inter',
              //                       fontWeight: FontWeight.w700,
              //                       fontSize: 10.sp,
              //                       letterSpacing: -0.4,
              //                       color: Color.fromRGBO(
              //                           255, 255, 255, 1)),
              //                 ),
              //               ))
              //       ],
              //     ),
              //     decoration: BoxDecoration(
              //       color: Get.isDarkMode
              //           ? Color.fromRGBO(19, 20, 21, 1)
              //           : Colors.white,
              //       borderRadius: BorderRadius.circular(20),
              //       boxShadow: <BoxShadow>[
              //         if (height > 0)
              //           BoxShadow(
              //               offset: Offset(0, 0),
              //               blurRadius: 2,
              //               spreadRadius: 2,
              //               color: Color.fromRGBO(78, 72, 72, 0.64))
              //       ],
              //     ),
              //   );
              // })
              //   ],
              // ),
              // ),
              // if (height - 60 > 0)
              //   SizedBox(
              //     height: height - 207 > 0 ? height - 207 : 0,
              //   ),
              if (height - 60 > 0)
                // Container(
                //     margin:
                //         EdgeInsets.symmetric(horizontal: height > 0 ? 10 : 15),
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                // ClipRRect(
                //     borderRadius: BorderRadius.circular(10),
                //     child: BackdropFilter(
                //         filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                //         child: Container(
                //           width: 0.19.sw,
                //           height: height - 192 > 0 ? height - 192 : 0,
                //           padding: EdgeInsets.all(10),
                //           decoration: BoxDecoration(
                //               color:
                //                   Color.fromRGBO(255, 255, 255, 0.17),
                //               borderRadius: BorderRadius.circular(10)),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             mainAxisSize: MainAxisSize.min,
                //             children: <Widget>[
                //               Icon(
                //                 const IconData(0xf18e,
                //                     fontFamily: 'MIcon'),
                //                 size: 12.sp,
                //                 color: Color.fromRGBO(255, 161, 0, 1),
                //               ),
                //               SizedBox(
                //                 width: 7,
                //               ),
                //               Text(
                //                 "${shop.rating}",
                //                 style: TextStyle(
                //                     fontFamily: 'Inter',
                //                     fontWeight: FontWeight.w500,
                //                     fontSize: 10.sp,
                //                     letterSpacing: -0.4,
                //                     color: Color.fromRGBO(
                //                         255, 255, 255, 1)),
                //               )
                //             ],
                //           ),
                //         ))),
                // ClipRRect(
                //     borderRadius: BorderRadius.circular(10),
                //     child: BackdropFilter(
                //         filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                //         child: Container(
                //           //width: 0.40.sw,
                //           padding: EdgeInsets.symmetric(
                //               vertical: 10, horizontal: 15),
                //           height: height - 192 > 0 ? height - 192 : 0,
                //           decoration: BoxDecoration(
                //               color:
                //                   Color.fromRGBO(255, 255, 255, 0.17),
                //               borderRadius: BorderRadius.circular(10)),
                //           child: Row(
                //             mainAxisAlignment:
                //                 MainAxisAlignment.spaceEvenly,
                //             children: <Widget>[
                //               if (shop.deliveryType == 3 ||
                //                   shop.deliveryType == 1)
                //                 Container(
                //                   child: Row(
                //                     children: <Widget>[
                //                       Icon(
                //                         const IconData(0xf1e1,
                //                             fontFamily: 'MIcon'),
                //                         color: Colors.white,
                //                         size: 12.sp,
                //                       ),
                //                       SizedBox(
                //                         width: 7,
                //                       ),
                //                       Text(
                //                         "Delivery".tr,
                //                         style: TextStyle(
                //                             fontFamily: 'Inter',
                //                             fontWeight: FontWeight.w600,
                //                             fontSize: 10.sp,
                //                             letterSpacing: -0.5,
                //                             color: Color.fromRGBO(
                //                                 255, 255, 255, 1)),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               if (shop.deliveryType == 3)
                //                 SizedBox(
                //                   width: 10,
                //                 ),
                //               if (shop.deliveryType == 3)
                //                 VerticalDivider(
                //                   width: 1,
                //                   color: Color.fromRGBO(
                //                       255, 255, 255, 0.12),
                //                 ),
                //               if (shop.deliveryType == 3)
                //                 SizedBox(
                //                   width: 10,
                //                 ),
                //               if (shop.deliveryType == 3 ||
                //                   shop.deliveryType == 2)
                //                 Container(
                //                   child: Row(
                //                     children: <Widget>[
                //                       Icon(
                //                         const IconData(0xf115,
                //                             fontFamily: 'MIcon'),
                //                         color: Colors.white,
                //                         size: 12.sp,
                //                       ),
                //                       SizedBox(
                //                         width: 7,
                //                       ),
                //                       Text(
                //                         "Pickup".tr,
                //                         style: TextStyle(
                //                             fontFamily: 'Inter',
                //                             fontWeight: FontWeight.w600,
                //                             fontSize: 10.sp,
                //                             letterSpacing: -0.5,
                //                             color: Color.fromRGBO(
                //                                 255, 255, 255, 1)),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //             ],
                //           ),
                //         )))
                //   ],
                // )

                // ),
                const SizedBox(
                  height: 10,
                ),
              if (height > 20)
                Container(
                  margin: const EdgeInsets.only(top: 0),
                  width: 1.sw,
                  height: 150.h,
                  child: Stack(
                    children: <Widget>[
                      // Positioned(
                      //     bottom: 0,
                      //     left: 0,
                      //     child: Container(
                      //         width: 1.sw,
                      //         height: 25,
                      //         color: Get.isDarkMode
                      //             ? Colors.white
                      //             //  const Color.fromRGBO(19, 20, 21, 1)
                      //             : Colors.white
                      //         // const Color.fromRGBO(243, 243, 240, 1),
                      //         )),
                      Container(
                          height: 160.h,
                          width: 1.sw - 10,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          padding: const EdgeInsets.all(0),
                          alignment: Alignment.topLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Get.isDarkMode
                                  ? const Color.fromRGBO(26, 34, 44, 1)
                                  : Colors.grey.shade100),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 4.0),
                            child: ListView(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "${shop.name}",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: -0.5,
                                          fontSize: 14.sp,
                                          color: height > 0
                                              ? Colors.black
                                              : Get.isDarkMode
                                                  ? const Color.fromRGBO(
                                                      255, 255, 255, 1)
                                                  : const Color.fromRGBO(
                                                      0, 0, 0, 1)),
                                    ),
                                    SizedBox(height: 5.h),
                                    Row(
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Flexible(
                                          // flex: 1,
                                          child: Icon(
                                            const IconData(0xef09,
                                                fontFamily: 'MIcon'),
                                            size: 14.sp,
                                            color: Get.isDarkMode
                                                ? const Color.fromRGBO(
                                                    130, 139, 150, 1)
                                                : const Color.fromRGBO(
                                                    136, 136, 126, 1),
                                          ),
                                        ),
                                        SizedBox(width: 5.w),
                                        Flexible(
                                          flex:1,
                                          child: Text(
                                            "${shop.address}",
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10.sp,
                                                letterSpacing: -0.4,
                                                color: Get.isDarkMode
                                                    ? const Color.fromRGBO(
                                                        130, 139, 150, 1)
                                                    : const Color.fromRGBO(
                                                        136, 136, 126, 1)),
                                          ),
                                        ),
                                        SizedBox(width: 10.w),
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: InkWell(
                                            onTap: () {
                                              _launchMap(
                                                shop.address,
                                              );
                                            },
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(
                                                      "lib/assets/images/Getdirection.png",
                                                      height: 25,
                                                      fit: BoxFit.contain,
                                                      width: 25),
                                                  SizedBox(height: 5.h),
                                                  Text(
                                                    "${shop.distance} km",
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10.sp,
                                                        letterSpacing: -0.4,
                                                        color: Get.isDarkMode
                                                            ? const Color
                                                                    .fromRGBO(
                                                                130,
                                                                139,
                                                                150,
                                                                1)
                                                            : const Color
                                                                    .fromRGBO(
                                                                136,
                                                                136,
                                                                126,
                                                                1)),
                                                  )
                                                ]),
                                          ),
                                        )
                                      ],
                                    ),
                                    // SizedBox(height: 3.h),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          fit: FlexFit.tight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Icon(
                                                const IconData(0xf18e,
                                                    fontFamily: 'MIcon'),
                                                size: 12.sp,
                                                color: Color.fromRGBO(
                                                    255, 161, 0, 1),
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                "${shop.rating}",
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.sp,
                                                    letterSpacing: -0.4,
                                                    color: Get.isDarkMode
                                                        ? Colors.white
                                                        : const Color.fromRGBO(
                                                            0, 0, 0, 1)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          flex: 4,
                                          fit: FlexFit.tight,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 12,
                                                width: 12,
                                                child: Image.asset(
                                                  "lib/assets/images/Chargestation.png",
                                                  height: 12,
                                                  width: 12,
                                                ),
                                              ),
                                              SizedBox(width: 5.w),
                                              Text(
                                                " ${shop.totalPorts} Ports ( ${shop.availablePorts}/${shop.totalPorts} Available)",
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 10.sp,
                                                    letterSpacing: -0.4,
                                                    color: Get.isDarkMode
                                                        ? Colors.white
                                                        : Color.fromRGBO(
                                                            0, 0, 0, 1)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                            flex: 1,
                                            fit: FlexFit.tight,
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.qr_code_2_rounded,
                                                color: Colors.blueGrey,
                                                size: 25,
                                              ),
                                              onPressed: () async {
                                                var qrdata = await FlutterBarcodeScanner
                                                        .scanBarcode(
                                                            "red",
                                                            "Cancel",
                                                            true,
                                                            ScanMode.QR);

                                                print(
                                                    '-------------------${qrdata.toString()}');
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
                                                  Get.toNamed("/home");
                                                }


                                              },
                                            ))
                                      ],
                                    )
                                    // InkWell(
                                    //   child: Container(
                                    //     child: Row(
                                    //       mainAxisSize: MainAxisSize.max,
                                    //       mainAxisAlignment: MainAxisAlignment.center,
                                    //       children: <Widget>[
                                    //         Icon(
                                    //           const IconData(0xee58,
                                    //               fontFamily: 'MIcon'),
                                    //           size: 16.sp,
                                    //           color: Color.fromRGBO(136, 136, 126, 1),
                                    //         ),
                                    //         SizedBox(
                                    //           width: 5,
                                    //         ),
                                    //         Text(
                                    //           "Market info".tr,
                                    //           style: TextStyle(
                                    //               fontFamily: 'Inter',
                                    //               fontWeight: FontWeight.w500,
                                    //               fontSize: 10.sp,
                                    //               letterSpacing: -0.5,
                                    //               color: Get.isDarkMode
                                    //                   ? Color.fromRGBO(
                                    //                       130, 139, 150, 1)
                                    //                   : Color.fromRGBO(
                                    //                       136, 136, 126, 1)),
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    //   onTap: () => Get.toNamed("/shopInfo",
                                    //       arguments: {"tab_index": 0}),
                                    // ),
                                    // VerticalDivider(
                                    //   width: 1,
                                    //   color: Color.fromRGBO(243, 243, 240, 1),
                                    // ),
                                    // InkWell(
                                    //     onTap: () => Get.toNamed("/shopInfo",
                                    //         arguments: {"tab_index": 1}),
                                    //     child: Container(
                                    //       child: Row(
                                    //         mainAxisSize: MainAxisSize.max,
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.center,
                                    //         children: <Widget>[
                                    //           Icon(
                                    //             const IconData(0xef17,
                                    //                 fontFamily: 'MIcon'),
                                    //             size: 16.sp,
                                    //             color:
                                    //                 Color.fromRGBO(136, 136, 126, 1),
                                    //           ),
                                    //           SizedBox(
                                    //             width: 5,
                                    //           ),
                                    //           Text(
                                    //             "Delivery time".tr,
                                    //             style: TextStyle(
                                    //                 fontFamily: 'Inter',
                                    //                 fontWeight: FontWeight.w500,
                                    //                 fontSize: 10.sp,
                                    //                 letterSpacing: -0.5,
                                    //                 color: Get.isDarkMode
                                    //                     ? Color.fromRGBO(
                                    //                         130, 139, 150, 1)
                                    //                     : Color.fromRGBO(
                                    //                         136, 136, 126, 1)),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     )),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
            ]),
          ),
        );
      }),
    );
  }
}
