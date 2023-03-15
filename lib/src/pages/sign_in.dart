import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samku/src/controllers/sign_in_controller.dart';

import '/src/components/password_input.dart';
import '/src/components/sign_button.dart';
import '/src/components/text_input.dart';

class SignInPage extends /*GetView<SignInController>*/ StatelessWidget {
  //const SignInPage({Key? key}) : super(key: key);
  final controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      body: SingleChildScrollView(
        child: Container(
          width: 1.sw,
          height: 1.sh,
          child: Stack(children: <Widget>[
            Container(
                width: 1.sw,
                height: 30,
                margin: EdgeInsets.only(top: 0.075.sh, right: 16, left: 30),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset("lib/assets/images/samkuEV.png"),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/signup");
                      },
                      child: Text(
                        "Sign Up".tr,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 20.sp,
                            letterSpacing: -1,
                            color: Color.fromRGBO(69, 165, 36, 1)),
                      ),
                    )
                  ],
                )),
            Positioned(
              height: 400,
              left: 90,
              right: 90,
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 0.05.sh),
                child: Image(
                  // image: AssetImage(Get.isDarkMode
                  //     ? "lib/assets/imagesSymbol.png"
                  //     : "lib/assets/images/Symbol.png"),
                  image: AssetImage(Get.isDarkMode
                      ? "lib/assets/images/light_mode/Symbol.png"
                      : "lib/assets/images/light_mode/Symbol.png"),
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
                bottom: 0,
                child: Obx(() {
                  return Container(
                      width: 1.sw,
                      padding: EdgeInsets.only(
                          top: 0.022.sh,
                          left: 0.0725.sw,
                          right: 0.0725.sw,
                          bottom: 0.08.sh),
                      decoration: BoxDecoration(
                          color: Get.isDarkMode
                              ? Color.fromRGBO(37, 48, 63, 1)
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Sign In".tr,
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 35.sp,
                                  letterSpacing: -2,
                                  color: Get.isDarkMode
                                      ? Color.fromRGBO(255, 255, 255, 1)
                                      : Color.fromRGBO(0, 0, 0, 1)),
                            ),
                            margin: EdgeInsets.only(bottom: 0.023.sh),
                          ),
                          TextInput(
                              title: "Phone number".tr,
                              prefix: "+91 ",
                              defaultValue: controller.phone.value,
                              type: TextInputType.number,
                              onChange: controller.onChangePhone,
                              placeholder: "+91 8909000000"),
                          Divider(
                            color: Get.isDarkMode
                                ? Color.fromRGBO(255, 255, 255, 1)
                                : Color.fromRGBO(0, 0, 0, 1),
                            height: 1,
                          ),
                          SizedBox(height:10.0),
                          //commented on 25.05.2022
                          // PasswordInput(
                          //   title: "Password".tr,
                          //   onChange: controller.onChangePassword,
                          // ),
                          // TextButton(
                          //     onPressed: () => Get.toNamed("/forgotPassword"),
                          //     style: ButtonStyle(
                          //         padding: MaterialStateProperty.all<
                          //             EdgeInsetsGeometry>(EdgeInsets.all(0))),
                          //     child: Container(
                          //       margin: EdgeInsets.only(
                          //           top: 0.034.sh, bottom: 0.066.sh),
                          //       child: Row(
                          //         children: <Widget>[
                          //           Container(
                          //             child: Icon(
                          //               const IconData(0xeecf,
                          //                   fontFamily: "MIcon"),
                          //               color: Color.fromRGBO(69, 165, 36, 1),
                          //               size: 20.sp,
                          //             ),
                          //             margin: EdgeInsets.only(right: 12),
                          //           ),
                          //           Text(
                          //             "Forgot password".tr,
                          //             style: TextStyle(
                          //               fontFamily: 'Inter',
                          //               fontWeight: FontWeight.w500,
                          //               fontSize: 14.sp,
                          //               letterSpacing: -0.5,
                          //               color: Color.fromRGBO(69, 165, 36, 1),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     )),
                          SignButton(
                            title: "Sign In".tr,
                            loading: controller.loading.value,
                            // onClick: controller.signInWithPhone,
                            onClick: controller.VerifyWithPhone,
                          )
                        ],
                      ));
                })),
          ]),
        ),
      ),
    );
  }
}
