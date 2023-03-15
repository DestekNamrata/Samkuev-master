import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samku/src/controllers/product_controller.dart';

import '/src/components/category_item.dart';
import '/src/components/category_products_item.dart';
import '/src/components/empty.dart';
import '/src/components/shadows/category_item_shadow.dart';
import '/src/components/shadows/category_product_item_shadow.dart';
import '/src/controllers/category_controller.dart';
import '/src/models/category.dart';
import '/src/models/product.dart';

class CategoryProductsUpdated extends StatefulWidget {
  int? qrData;
  CategoryProductsUpdated({Key? key, this.qrData}):super(key:key);
  CategoryProductsUpdatedState createState()=>CategoryProductsUpdatedState();
}

class CategoryProductsUpdatedState extends State<CategoryProductsUpdated>{

  final CategoryController categoryController = Get.put(CategoryController());
  ProductController productController = Get.put(ProductController());


  // int id = 3;
  int id = 3;
  var tabIndex = 0.obs;
  int listIndexClicked = 0;
  bool flagStart = false;
  var isSelectedIndex = -1.obs;
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
        categoryController.activeCategory.value.id=categoryController.activeCategory.value.id??3;
        categoryController.inActiveCategory.value = categoryController.activeCategory.value;
        categoryController.productController
            .clearFilter();
        categoryController.load.value = true;
        flagStart=true;
      }

      return SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        controller: categoryController.scrollController,
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
                            future: categoryController.getCategories(3, -1, 0),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<Category> categories = snapshot.data!;
                                // if(categories.length>0)
                                //   {
                                    return ListView.builder(
                                        itemCount: categories.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {

                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                isSelectedIndex=-1;
                                              });
                                              tabIndex.value=index;
                                              categoryController.inActiveCategory.value = categoryController.activeCategory.value;
                                              categoryController.activeCategory.value = Category(id: categories[index].id, name: categories[index].name);
                                              categoryController.productController.clearFilter();

                                              categoryController.load.value = true;
                                              categoryController.qrData=null;
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
                                //   }else{
                                //   // setState(() {
                                //     categoryController.activeCategory.value.id=0;
                                //
                                //   // });
                                //
                                // }
                              }
                              else if (snapshot.hasError) {
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
                future: categoryController.getCategoryProducts(
                    categoryController.activeCategory.value.id!, false),
                builder: (context, snapshot) {
                  if (snapshot.hasData && !categoryController.load.value)
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
                              // CategoryProductItem(
                              //     product: products[index],
                              //     qrData:widget.qrData,
                              //     index:index
                              // ),

                             Card(
                            color: isSelectedIndex==index?Colors.green:Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              elevation: 1,
                              shadowColor: Colors.grey,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  selectedColor: Colors.green,
                                  selectedTileColor: Colors.green,
                                  selected: false,
                                  onTap: () {
                                    setState(() {
                                      isSelectedIndex=index;
                                      productController.activeProduct.value.id;
                                      categoryController.qrData = product.id;
                                      categoryController.productController.activeProduct.value.status=product.status;
                                      productController.selectedIndex.value=index;
                                    });


                                    // Get.to(Home(qrdata: product!.id), arguments: [
                                    //   {},
                                    // ]);
                                    // qrData = product!.id;
                                    // Get.to(Home(qrdata: qrData));
                                  },
                                  dense: true,
                                  isThreeLine: true,
                                  leading: Image.network(
                                    "${product.image}",
                                    width: 0.2.sw,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(child:Text('${product.name}',
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 14.sp,
                                                  color: isSelectedIndex==index?Colors.white:Colors.black))),
                                          Container(
                                            height: 25,
                                            width: 0.25.sw,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                color: product.status == 1 //available
                                                    ? Colors.green
                                                    : product.status == 2 //currently using
                                                    ? Colors.yellow
                                                    : product.status == 3 //notworking
                                                    ? Colors.red
                                                    : Colors.black), //faulty
                                            child: Center(
                                              child: Text("${product.statusName}",
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
                                      Text('${product.chargingType}',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18.sp,
                                              color: isSelectedIndex==index?Colors.white:Colors.black)),
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
                                      Text("\u20b9 ${product.price}/h ",
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontWeight: FontWeight.w300,
                                              fontSize: 18.sp,
                                              color: isSelectedIndex==index?Colors.white:Colors.black)),
                                      SizedBox(width: 15.w),
                                      Icon(
                                        const IconData(0xf239, fontFamily: 'MaterialIcons'),
                                        size: 20.sp,
                                        color: Get.isDarkMode
                                            ? const Color.fromRGBO(130, 139, 150, 1)
                                            : const Color.fromRGBO(100, 200, 100, 1),
                                      ),
                                      SizedBox(width: 10.w),
                                      Text(
                                        "${product.power} kw ",
                                        style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18.sp,
                                            color: isSelectedIndex==index?Colors.white:Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
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
            if (categoryController.load.value)
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
