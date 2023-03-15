import 'package:samku/src/controllers/category_controller.dart';
import 'package:samku/src/pages/category_products.dart';
import 'package:samku/src/pages/category_products_updated.dart';
import 'package:samku/src/pages/chargedetails.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:samku/src/pages/prebook_details.dart';

import '/src/components/home_silver_bar.dart';
import '/src/controllers/auth_controller.dart';
import '/src/controllers/notification_controller.dart';

class Home extends StatefulWidget {
  int? qrdata;
  Home({Key? key, this.qrdata}) : super(key: key);
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());
  final CategoryController categoryController = Get.put(CategoryController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  // int tabIndex = 2;
  bool onClick = true;

  @override
  void initState() {
    super.initState();
    notificationController.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Colors.white
          // Color.fromRGBO(19, 20, 21, 1)
          : Colors.grey.shade50,
      // Color.fromRGBO(243, 243, 240, 1),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[HomeSilverBar()];
        },
        body: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100, top: 30),
            child: Column(
              children: <Widget>[
                // Banners(),
                //  HomeTabs(),
                // Categories(),
                //  SubCategoryProducts(),
                // CategoryProducts(qrData:widget.qrdata),
                CategoryProductsUpdated(qrData:widget.qrdata),
                //  HomeBrands(),
                //  HomeCategory(),
              ],
            )),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextButton(
                child: Text("Pre Book", style: TextStyle(fontSize: 14)),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.fromLTRB(40, 15, 40, 15)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide(color: Colors.green)))),
                onPressed: () {
                  // Fluttertoast.showToast(
                  // msg: "Coming soon",
                  // toastLength: Toast.LENGTH_SHORT,
                  // gravity: ToastGravity.BOTTOM,
                  // timeInSecForIosWeb: 1,
                  // backgroundColor: Colors.green,
                  // textColor: Colors.white,
                  // fontSize: 16.0)
                  if (categoryController.productController.activeProduct.value.status!=2 && categoryController.qrData != null) {

                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => PreBookDetails()));
                  } else {
                    Fluttertoast.showToast(msg: "Please select valid Port");
                  }
                }

            ),
            // SizedBox(width: 100),
            TextButton(
                child: Text("Book Now", style: TextStyle(fontSize: 14)),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.fromLTRB(40, 15, 40, 15)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),
                            side: BorderSide(color: Colors.green)))),
                onPressed: () {
                  // Future.delayed(Duration(milliseconds: 100), () {
                  //   print(
                  //       "widget.qrdatawidget.qrdata+++++++++${widget.qrdata!}");
                  print(categoryController.qrData);
                  if (categoryController.productController.activeProduct.value.status!=2 && categoryController.qrData != null) {
                    Get.off(
                      ChargeingDetails(qrdata: categoryController.qrData!),
                    );
                  } else {
                    Fluttertoast.showToast(msg: "Please select valid Port");
                  }
                }
                ),
          ],
        ),
      ),
    );
  }
}
