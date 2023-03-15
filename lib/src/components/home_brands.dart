import 'package:samku/src/controllers/category_controller.dart';
import 'package:samku/src/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/src/components/shadows/home_brand_item_shadow.dart';

class HomeBrands extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 32),
      child: Column(
        children: <Widget>[
          // Container(
          //   margin: EdgeInsets.symmetric(horizontal: 15),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: <Widget>[
          //       Text(
          //         "Brands".tr,
          //         style: TextStyle(
          //             fontFamily: 'Inter',
          //             fontWeight: FontWeight.w500,
          //             fontSize: 20.sp,
          //             letterSpacing: -1,
          //             color: Get.isDarkMode
          //                 ? Color.fromRGBO(255, 255, 255, 1)
          //                 : Color.fromRGBO(0, 0, 0, 1)),
          //       ),
          //       InkWell(
          //         child: Text(
          //           "View more".tr,
          //           style: TextStyle(
          //               fontFamily: 'Inter',
          //               fontWeight: FontWeight.w500,
          //               fontSize: 14.sp,
          //               letterSpacing: -0.5,
          //               color: Color.fromRGBO(53, 105, 184, 1)),
          //         ),
          //         onTap: () => Get.toNamed("/brands"),
          //       ),
          //     ],
          //   ),
          // ),
          Container(
              height: 0.5.sh,
              margin: EdgeInsets.only(top: 18),
              width: 1.sw,
              child: FutureBuilder<List<Product>>(
                future: controller.getCategoryProducts(4, false),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Product> products = snapshot.data ?? [];
                    return ListView.builder(
                        itemCount: products.length,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemBuilder: (context, index) {
                          Product product = products[index];
                          print(product.toString());

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            color: Colors.grey.shade50,
                            margin: const EdgeInsets.all(10.0),
                            child: ListTile(
                              minVerticalPadding: 10.0,
                              contentPadding: const EdgeInsets.all(10.0),
                              // leading: Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 10.0),
                              //   child: SizedBox(
                              //     height: 70,
                              //     child: Image.network(
                              //       "${product.images}",
                              //       fit: BoxFit.fitHeight,
                              //     ),
                              //     // child: Image.asset(
                              //     //   'lib/assets/images/AC 3 Pin.png',
                              //     //   fit: BoxFit.contain,
                              //     // ),
                              //   ),
                              // ),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Charger-1, port 1",
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w300,
                                              fontSize: 14.sp,
                                              color: Colors.black)),
                                      Container(
                                        height: 25,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Get.isDarkMode
                                                ? const Color.fromRGBO(
                                                    26, 34, 44, 1)
                                                : Colors.green),
                                        // color: Colors.green,
                                        child: Center(
                                          child: Text("Available",
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp,
                                                  color: Colors.white)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  Text("AC 3 Pin, 3 pin",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18.sp,
                                          color: Colors.black)),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time_filled_sharp,
                                    color: Colors.black,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text("\u20b9 200/h ",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w300,
                                          fontSize: 18.sp,
                                          color: Colors.black)),
                                  SizedBox(width: 15.w),
                                  Icon(
                                    const IconData(0xf239,
                                        fontFamily: 'MaterialIcons'),
                                    size: 20.sp,
                                    color: Get.isDarkMode
                                        ? const Color.fromRGBO(130, 139, 150, 1)
                                        : const Color.fromRGBO(
                                            100, 200, 100, 1),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "3.3 kw ",
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18.sp,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          );
                          // return HomeBrandItem(
                          //   id: brand.id,
                          //   name: brand.name,
                          //   imageUrl: brand.imageUrl,
                          // );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return ListView.builder(
                      itemCount: 10,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      itemBuilder: (context, index) {
                        return HomeBrandItemShadow();
                      });
                },
              ))
        ],
      ),
    );
  }
}
