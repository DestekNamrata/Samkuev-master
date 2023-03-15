import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '/src/components/category_item.dart';
import '/src/components/category_products_item.dart';
import '/src/components/empty.dart';
import '/src/components/shadows/category_item_shadow.dart';
import '/src/components/shadows/category_product_item_shadow.dart';
import '/src/controllers/category_controller.dart';
import '/src/models/category.dart';
import '/src/models/product.dart';

class CategoryProducts extends GetView<CategoryController> {
  int? qrData;
  CategoryProducts({Key? key,this.qrData}):super(key: key);
  final CategoryController categoryController = Get.put(CategoryController());
  // int id = 3;
  int id = 3;
  var tabIndex = 0.obs;
  int listIndexClicked=0;
  bool flagStart=false;
  var isSelectedIndex=0.obs;


  Widget loading() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            CategoryProductItemShadow(),
            // CategoryProductItemShadow()
          ],
        ),
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: <Widget>[
        //     CategoryProductItemShadow(),
        //     // CategoryProductItemShadow()
        //   ],
        // ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(flagStart==false){
        id = categoryController.activeCategory.value.id ?? 3;
        controller.activeCategory.value.id=categoryController.activeCategory.value.id??3;
        controller.inActiveCategory.value = controller.activeCategory.value;
        controller.productController
            .clearFilter();
        controller.load.value = true;
        flagStart=true;
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          width: 0.9.sw,
                          height: 0.06.sh,
                          // decoration: BoxDecoration(
                          //     color: Colors.grey.shade100,
                          //     borderRadius: BorderRadius.circular(60)
                          // ),
                          child: FutureBuilder<List<Category>>(
                            // future: controller.getCategories(id, -1, 0),
                            future: controller.getCategories(3, -1, 0),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Category> categories = snapshot.data!;
                                return ListView.builder(

                                    itemCount: categories.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      // return CategoryItem(
                                      //   name: categories[index].name,
                                      //   id: categories[index].id,
                                      //   isActive:
                                      //       controller.activeCategory.value ==
                                      //           categories[index],
                                      //   onClick: () =>
                                      //       controller.onChangeProductType(
                                      //           categories[index]),
                                      // );
                                      return InkWell(
                                        onTap: () {
                                          tabIndex.value=index;
                                          controller.inActiveCategory.value = controller.activeCategory.value;
                                          controller.activeCategory.value = Category(id: categories[index].id, name: categories[index].name);
                                          controller.productController.clearFilter();

                                          controller.load.value = true;
                                          controller.qrData=null;
                                          print("id:-"+id.toString());
                                          // controller.categoryProductList[id ?? 3] = [];
                                          // Get.toNamed("/subCategoryProducts");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Container(
                                            height: 0.05.sh,
                                            width: 0.28.sw,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(60),
                                              color: tabIndex.value==index
                                                  ? const Color.fromRGBO(69, 165, 36, 1)
                                                  : const Color.fromRGBO(233, 233, 230, 1),
                                            ),
                                            child: Center(
                                              child: Text(
                                                categories[index].name.toString(),
                                                style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14.sp,
                                                  letterSpacing: -0.2,
                                                  color: tabIndex.value==index
                                                ? Colors.white
                                                      :Colors.black,

                                                  // color: id != null
                                                  //     ? Colors.white
                                                  //     : Get.isDarkMode
                                                  //         ? Colors.white
                                                  //         : Colors.black
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        // child: Center(
                                        //   child: Text(
                                        //     "$name",
                                        //     maxLines: 2,
                                        //     overflow: TextOverflow.clip,
                                        //     textAlign: TextAlign.center,
                                        //     style: TextStyle(
                                        //         fontFamily: 'Inter',
                                        //         fontWeight: FontWeight.w500,
                                        //         fontSize: 14.sp,
                                        //         letterSpacing: -0.58,
                                        //         color: Get.isDarkMode
                                        //             ? Color.fromRGBO(255, 255, 255, 1)
                                        //             : Color.fromRGBO(0, 0, 0, 1)),
                                        //   ),
                                        // ),
                                      );
                                    });
                                // return  ClipRRect(
                                //     borderRadius: BorderRadius.circular(10),
                                //     child: SizedBox(
                                //         height: 34,
                                //         width: 0.9.sw,
                                //         child: ListView.builder(
                                //             itemCount: categories.length,
                                //             scrollDirection: Axis.horizontal,
                                //             itemBuilder: (context, index) {
                                //               return Obx(() => InkWell(
                                //                 child: Container(
                                //                   padding:
                                //                   const EdgeInsets
                                //                       .symmetric(
                                //                       horizontal: 20),
                                //                   margin: const EdgeInsets
                                //                       .only(right: 8),
                                //                   height: 34,
                                //                   alignment:
                                //                   Alignment.center,
                                //                   decoration:
                                //                   BoxDecoration(
                                //                       color:
                                //                           tabIndex.value ==
                                //                           index
                                //                           ? const Color.fromRGBO(69, 165, 36, 1)
                                //                           : Get.isDarkMode
                                //                           ? const Color.fromRGBO(26, 34, 44, 1)
                                //                           : const Color.fromRGBO(233, 233, 230, 1),
                                //                       borderRadius:
                                //                       BorderRadius.circular(40)),
                                //                   child:
                                //                   // call api for brands
                                //                   //showBrands();
                                //                   Text(
                                //                     categories[index].name.toString(),
                                //                     style: TextStyle(
                                //                         fontFamily: 'Inter',
                                //                         fontWeight: FontWeight.w500,
                                //                         fontSize: 14.sp,
                                //                         letterSpacing:
                                //                         -0.5,
                                //                         color: tabIndex.value == index
                                //                             ? Colors.white
                                //                             : Get.isDarkMode
                                //                             ? Colors.white
                                //                             : const Color
                                //                             .fromRGBO(0, 0, 0, 1)),
                                //                   ),
                                //                 ),
                                //                 onTap: () {
                                //                   tabIndex.value = index;
                                //                   controller.onChangeProductType(categories[index]);
                                //                   controller.inActiveCategory.value = controller.activeCategory.value;
                                //                   controller.activeCategory.value = Category(id: categories[index].id, name: categories[index].name);
                                //                   controller.productController.clearFilter();
                                //                   controller.load.value = true;
                                //                   controller.categoryProductList[id ?? 3] = [];
                                //                   //call brand wise stations API
                                //                   //https://{{demo_url}}/api/m/brands/shops
                                //                 },
                                //               ));
                                //             })));
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }
                              return ListView.builder(
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return CategoryItemShadow();
                                  });
                            },
                          )))
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 2.sh,
              child: FutureBuilder<List<Product>>(
                future: controller.getCategoryProducts(
                    controller.activeCategory.value.id!, false),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !controller.load.value)
                    // (!controller.load.value || controller.categoryProductList[id]!.isNotEmpty))
                  {
                    List<Widget> row = [];
                    if (snapshot.hasData) {
                      List<Product> products = snapshot.data ?? [];
                      return products.isNotEmpty
                          ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              scrollDirection: Axis.vertical,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              itemBuilder: (context, index) {
                                Product product = products[index];
                                print(product.toString());
                                return Container(
                                  child:
                                  CategoryProductItem(
                                    product: products[index],
                                    qrData:qrData,
                                    index:index
                                  ),
                                );
                              })
                          // added on 11-3-22
                          // : row.isEmpty
                          //     ? Empty(message: "No products".tr)
                          //     : Container(
                          //         padding: const EdgeInsets.symmetric(
                          //             horizontal: 15),
                          //         child: Column(
                          //           children: row.toList(),
                          //         ),
                          //       );
                          : Container(
                              child: Text(
                              "No data found",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12),
                            ));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // for (int i = 0; i < products.length; i++) {
                    //   subRow.add(CategoryProductItem(
                    //     product: products[i],
                    //   ));

                    //   if ((i + 1) % 2 == 0 || (i + 1) == products.length) {
                    //     row.add(Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: subRow.toList(),
                    //     ));

                    //     subRow = [];
                    //   }
                    // }

                    return row.isEmpty
                        ? Empty(message: "No products".tr)
                        : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: row.toList(),
                            ),
                          );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } /* else {
                    return Container(
                        child: Text(
                      "Select Categories",
                      style: TextStyle(color: Colors.black, fontSize: 10),
                    ));
                  }*/
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: loading(),
                  );
                },
              ),
            ),
            if (controller.load.value)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: loading(),
              )
          ],
        ),
      );
    });
  }
}
