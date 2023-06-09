import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/src/components/appbar.dart';
import '/src/components/empty.dart';
import '/src/controllers/about_controller.dart';

class Privacy extends GetView<AboutControler> {
  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      appBar: PreferredSize(
          preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
          child: AppBarCustom(
            title: "Privacy".tr,
            hasBack: true,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // if (controller.shopController.defaultShop.value != null &&
            //     controller.shopController.defaultShop.value!.id != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: FutureBuilder<String>(
                  future: controller.getPrivacyContent(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Html(data: snapshot.data);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return Container();
                  },
                ),
              ),
            // if (controller.shopController.defaultShop.value == null ||
            //     controller.shopController.defaultShop.value!.id == null)
            //   Empty(message: "To see privacy, please, select shop")
          ],
        ),
      ),
    );
  }
}
