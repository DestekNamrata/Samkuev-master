import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/src/components/appbar.dart';
import '/src/components/category_products_item.dart';
import '/src/components/empty.dart';
import '/src/components/filter.dart';
import '/src/components/search_input.dart';
import '/src/components/shadows/category_product_item_shadow.dart';
import '/src/controllers/category_controller.dart';
import '/src/models/product.dart';

class SubCategoryProducts extends GetView<CategoryController> {
  Widget loading() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CategoryProductItemShadow(),
            CategoryProductItemShadow()
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CategoryProductItemShadow(),
            CategoryProductItemShadow()
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String name = controller.activeCategory.value.name!;
      int id = controller.activeCategory.value.id!;
      var statusBarHeight = MediaQuery.of(context).padding.top;
      var appBarHeight = AppBar().preferredSize.height;

      return Scaffold(
        backgroundColor: Get.isDarkMode
            ? Color.fromRGBO(19, 20, 21, 1)
            : Color.fromRGBO(243, 243, 240, 1),
        appBar: PreferredSize(
            preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
            child: AppBarCustom(
              title: "$name",
              hasBack: true,
              onBack: () {
                controller.activeCategory.value =
                    controller.inActiveCategory.value;
                controller.productController.clearFilter();
                controller.load.value = true;
                controller.categoryProductList[id] = [];
              },
            )),
        body: Scrollbar(
            child: SingleChildScrollView(
          controller: controller.subScrollController,
          child: Column(
            children: <Widget>[
              SearchInput(
                title: "Search products".tr,
                onChange: (text) {
                  controller.load.value = true;
                  controller.categoryProductList[id] = [];
                  controller.categoryProductList.refresh();
                  controller.productController.searchText.value = text;
                },
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) {
                        return Filter(
                          onPress: () {
                            controller.load.value = true;
                            controller.categoryProductList[id] = [];
                            controller.categoryProductList.refresh();
                            //Get.back();
                          },
                        );
                      });
                },
              ),
              Container(
                  width: 1.sw,
                  child: Column(
                    children: <Widget>[
                      FutureBuilder<List<Product>>(
                        future: controller.getCategoryProducts(id, false),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              (!controller.load.value ||
                                  controller.categoryProductList[id]!.length >
                                      0)) {
                            List<Product> products = snapshot.data!;

                            List<Widget> row = [];
                            List<Widget> subRow = [];

                            for (int i = 0; i < products.length; i++) {
                              subRow.add(CategoryProductItem(
                                product: products[i],
                              ));

                              if ((i + 1) % 2 == 0 ||
                                  (i + 1) == products.length) {
                                row.add(Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: subRow.toList(),
                                ));

                                subRow = [];
                              }
                            }

                            return row.length == 0
                                ? Empty(message: "No products".tr)
                                : Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Column(
                                      children: row.toList(),
                                    ),
                                  );
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }

                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: loading(),
                          );
                        },
                      ),
                      if (controller.load.value)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: loading(),
                        )
                    ],
                  ))
            ],
          ),
        )),
      );
    });
  }
}
