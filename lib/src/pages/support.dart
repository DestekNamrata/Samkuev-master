import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../components/appbar.dart';

class SupportScreen extends StatefulWidget{
  _SupportState createState()=>_SupportState();
}

class _SupportState extends State<SupportScreen>{
  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = AppBar().preferredSize.height;
    // TODO: implement build
    return Scaffold(
        backgroundColor: Get.isDarkMode
            ? Color.fromRGBO(19, 20, 21, 1)
            : Color.fromRGBO(243, 243, 240, 1),
        appBar: PreferredSize(
            preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
            child: AppBarCustom(
              title: "Support".tr,
              hasBack: true,
            )),
        body:Padding(
          padding: const EdgeInsets.all(10.0),
          child:
          Container(
            child: Column(
              children: [
                SizedBox(height: 30.0,),

                Image.asset(
                  'lib/assets/images/Symbol.png',
                  // width: double.infinity,
                  height: 150.0,
                  width: 150.0,
                ),
                SizedBox(height: 15.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(
                    "Email : ".tr,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        letterSpacing: -0.4,
                        color: Colors.black),
                  ),
                  Text(
                    "Samkuev@gmail.com".tr,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        letterSpacing: -0.4,
                        color: Colors.black),
                  )
                ],),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                  Text(
                    "Mobile Number : ".tr,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        letterSpacing: -0.4,
                        color: Colors.black),
                  ),
                  Text(
                    "9730632367".tr,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        letterSpacing: -0.4,
                        color: Colors.black),
                  )
                ],)

              ],
            ),
          ),
        )
    );
  }

}