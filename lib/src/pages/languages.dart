import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/src/components/appbar.dart';
import '/src/components/language_item.dart';
import '/src/components/search_input.dart';
import '/src/controllers/language_controller.dart';

class Languages extends GetView<LanguageController> {
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
            title: "Language".tr,
            hasBack: true,
          )),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SearchInput(
              title: "Search language".tr,
              hasSuffix: false,
              onChange: (text) => controller.onSearch(text),
            ),
            SizedBox(
              height: 20,
            ),
            Obx(() {
              return Column(
                children: controller.languages.map((item) {
                  return LanguageItem(
                    isChecked: controller.activeLanguageId.value == item.id,
                    text: item.name,
                    imageUrl: item.image,
                    onPress: () {
                      controller.language.value = item.shortName!;
                      controller.activeLanguageId.value = item.id!;

                      var locale = Locale(item.shortName!, "US");
                      Get.updateLocale(locale);

                      controller.reload();
                    },
                  );
                }).toList(),
              );
            })
          ],
        ),
      ),
    );
  }
}
