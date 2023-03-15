import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '/config/global_config.dart';
import '/src/controllers/category_controller.dart';
import '/src/models/category.dart';

class CategoryItem extends GetView<CategoryController> {
  final String? imageUrl;
  final int? id;
  final String? name;
  final bool? isActive;
  final Function()? onClick;


  const CategoryItem(
      {this.id, this.imageUrl, this.name, this.isActive, this.onClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // onClick;
        controller.inActiveCategory.value = controller.activeCategory.value;
        controller.activeCategory.value = Category(id: id, name: name);
        controller.productController.clearFilter();
        controller.load.value = true;
        controller.categoryProductList[id ?? 3] = [];
        // Get.toNamed("/subCategoryProducts");
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 0.05.sh,
          width: 0.3.sw,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: controller.load.isTrue
                  ? const Color.fromRGBO(69, 165, 36, 1)
                  : const Color.fromRGBO(233, 233, 230, 1),
              ),
          child: Center(
            child: Text(
              "$name",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                letterSpacing: -0.2,

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
  }
}
