import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/src/controllers/auth_controller.dart';

class Loading extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? const Color.fromRGBO(19, 20, 21, 1)
          : const Color.fromRGBO(243, 243, 240, 1),
      body: Container(
          // width: 1.sw,
          // height: 1.sh,
          // alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
            Center(
              child: Image.asset(
                'lib/assets/images/Symbol.png',
                // fit: BoxFit.contain,
                // width: double.infinity,
                // height: 1.sh,
              ),
            ),
            // ClipRRect(
            //     borderRadius: BorderRadius.circular(
            //       0.5.sw,
            //     ),
            //     child:
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Color.fromRGBO(69, 165, 36, 1),
              ),
              // )
            ),
          ])),
    );
  }
}
