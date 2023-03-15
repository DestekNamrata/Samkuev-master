import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/src/components/appbar.dart';
import '/src/components/currency_item.dart';
import '/src/components/empty.dart';
import '/src/controllers/currency_controller.dart';
import '/src/models/currency.dart' as CurrencyModel;

class Currency extends GetView<CurrencyController> {
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
            title: "Currency".tr,
            hasBack: true,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20,
              width: 1.sw,
            ),
            if (controller.shopController.defaultShop.value != null &&
                controller.shopController.defaultShop.value!.id != null)
              FutureBuilder<List<CurrencyModel.Currency>>(
                future: controller.getCurrencies(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<CurrencyModel.Currency> data = snapshot.data!;
                    return Obx(() => Column(
                          children: data.map((item) {
                            return CurrencyItem(
                              text: "${item.name} - (${item.symbol})",
                              isChecked:
                                  item.id == controller.activeCurrencyId.value,
                              onPress: () {
                                controller.setActiveCurrency(item.id!);
                              },
                            );
                          }).toList(),
                        ));
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }

                  return Container();
                },
              ),
            if (controller.shopController.defaultShop.value == null ||
                controller.shopController.defaultShop.value!.id == null)
              Empty(message: "To see currency, please, select shop")
          ],
        ),
      ),
    );
  }
}
