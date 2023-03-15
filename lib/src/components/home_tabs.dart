import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/src/components/home_tabs_item.dart';
import '/src/controllers/category_controller.dart';

class HomeTabs extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
                width: 0.75.sw,
                height: 0.05.sh,
                decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(60)),
                child: ListView.builder(
                    itemCount: controller.categoryProductList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Obx(() => HomeTabsItem(
                            title: controller.categoryList[index].toString(),
                            isActive: controller.tabIndex.value == index,
                            onTap: () {
                              controller.onChangeProductType(index);
                              
                            },
                          ));
                    }))),
      ],
    );
    // Container(
    //     height: 34,
    //     width: 1.sw,
    //     margin: EdgeInsets.only(top: 32),
    //     child: ListView.builder(
    //         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
    //         itemCount: controller.tabs.length,
    //         scrollDirection: Axis.horizontal,
    //         itemBuilder: (context, index) {
    //           return Obx(() => HomeTabsItem(
    //                 title: controller.tabs[index],
    //                 isActive: controller.tabIndex.value == index,
    //                 onTap: () {
    //                   controller.onChangeProductType(index);
    //                 },
    //               ));
    //         }));
  }
}
