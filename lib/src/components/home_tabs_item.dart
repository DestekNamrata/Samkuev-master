import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeTabsItem extends StatelessWidget {
  final String? title;
  final bool? isActive;
  final Function()? onTap;

  HomeTabsItem({this.title, this.isActive, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 0.05.sh,
        width: 0.25.sw,
        decoration: BoxDecoration(
          color: isActive!
              ? const Color.fromRGBO(69, 165, 36, 1)
              : Get.isDarkMode
                  ? const Color.fromRGBO(26, 34, 44, 1)
                  : const Color.fromRGBO(233, 233, 230, 1),
          // borderRadius: BorderRadius.circular(40)
        ),
        child: Center(
          child: Text(
            "$title",
            style: TextStyle(
                // backgroundColor: isActive!
                //     ? Colors.green
                //     : Get.isDarkMode
                //         ? Colors.white
                //         : Colors.white,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                letterSpacing: -0.2,
                color: isActive!
                    ? Colors.white
                    : Get.isDarkMode
                        ? Colors.white
                        : Colors.black),
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
