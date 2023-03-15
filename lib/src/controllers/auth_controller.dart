import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:samku/src/components/error_dialog.dart';

import '/src/components/success_alert.dart';
import '/src/controllers/order_controller.dart';
import '/src/models/user.dart';
import '/src/requests/update_user_request.dart';
import '/src/utils/utils.dart';

class AuthController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  var isConnected = true.obs;
  var user = Rxn<Users>();
  var token = "".obs;
  var profilePercentage = 0.obs;
  var showConfirmPassword = false.obs;
  var showNewPassword = false.obs;
  var showNewPasswordConfirm = false.obs;
  var currentPassword = "".obs;
  var newPassword = "".obs;
  var newPasswordConfirm = "".obs;

  final ImagePicker picker = ImagePicker();
  var profileImage = Rxn<XFile>();
  var name = "".obs;
  var surname = "".obs;
  var phone = "".obs;
  var email = "".obs;
  var gender = 0.obs;
  var image = "".obs;
  // var load = true.obs;
  var load = false.obs;
  var route = "".obs;
  var bikeName = "".obs;
  var bikenumber = "".obs;
  var modelnumber = "".obs;

  final OrderController orderController = Get.put(OrderController());


  @override
  void onInit() {
    super.onInit();

    connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      await getConnectivity();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Get.dialog(NotificationMessageDialog(
      //   message: message.notification!.title,
      //   onTap: () {
      //     Get.back();
      //     Get.toNamed("/notifications");
      //   },
      // ));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

    route.value = "";
  }

  @override
  void onReady() {
    super.onReady();

    getConnectivity();
    getPushToken();
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> getConnectivity() async {
    try {
      bool isConnectedResult = await Utils.checkInternetConnectivity();
      isConnected.value = isConnectedResult;
      Future.delayed(Duration(milliseconds: 3000), () {
        getUserInfoAndRedirect();
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
    return Future.value(null);
  }

  Future<void> getUserInfoAndRedirect() async {
    if (!isConnected.value)
      Get.offAndToNamed("/noConnection");
    else {
      final box = GetStorage();
      final user = box.read('user') ?? null;
      final language = box.read('language') ?? null;
      final addressList = box.read('addressList') ?? null;

      // if (isConnected.value) {
      //   Get.offAndToNamed("/splash")!.then((user) {
      //     if (user == null) {
      //       return Get.offAndToNamed("/signin");
      //     } else {
      //       return Get.offAndToNamed("/location");
      //       // .then((value) => Get.offAndToNamed("/location"));

      //       // .then(() {} Get.offAndToNamed("/location"));
      //     }
      //   });
      // }
      if (user != null) {
        // if (addressList == null) {
        // Future.delayed(Duration(milliseconds: 50), () {

        Get.offAllNamed("/location");
        // });

        // } else {
        //   //route.value = "store";
        //       Future.delayed(Duration(milliseconds: 100), () {
        //   Get.offAndToNamed("/splash");
        // });
        //   Get.offAndToNamed("/location");
        //   // Get.offAndToNamed("/store");
        // }
      } else {
        // Future.delayed(Duration(milliseconds: 100), () {
        //   Get.offAndToNamed("/splash");
        // });
        Get.offAndToNamed("/signin");
      }
    }
  }

  Users? getUser() {
    final box = GetStorage();
    final userData = box.read('user') ?? null;
    if (userData == null) {
      if (user.value != null && user.value!.id != null) {
        name.value = user.value!.name!;
        surname.value = user.value!.surname!;
        bikenumber.value = user.value!.bikenumber!;
        phone.value = user.value!.phone!;
        email.value = user.value!.email!;
        gender.value = user.value!.gender!;
        currentPassword.value = user.value!.password!;
        image.value = user.value!.imageUrl!;

        checkUser();
      }

      return user.value;
    } else {
      user.value = Users.fromJson(userData);
      if (user.value != null && user.value!.id != null) {
        name.value = user.value!.name!;
        surname.value = user.value!.surname!;
        phone.value = user.value!.phone!;
        email.value = user.value!.email!;
        gender.value = user.value!.gender!;
        currentPassword.value = user.value!.password ?? "";
        image.value = user.value!.imageUrl ?? "";
        bikeName.value = user.value!.bikeName ?? "";
        bikenumber.value = user.value!.bikenumber ?? "";
        modelnumber.value = user.value!.modelnumber ?? "";
      }
      checkUser();
    }

    return userData != null ? Users.fromJson(userData) : null;
  }

  void logout() {
    final box = GetStorage();
    box.remove('user');
    Get.offAllNamed("/signin");
  }

  Future<void> getPushToken() async {
    token.value = await FirebaseMessaging.instance.getToken() ?? "";
    token.refresh();
  }

  void checkUser() {
    profilePercentage.value = 0;
    if (name.value.length > 0) profilePercentage.value += 12;
    if (surname.value.length > 0) profilePercentage.value += 12;
    if (bikenumber.value.length > 0) profilePercentage.value += 12;
    if (phone.value.length > 0) profilePercentage.value += 12;
    if (email.value.length > 0) profilePercentage.value += 12;
    if (gender.value >= 0) profilePercentage.value += 12;
    if (currentPassword.value.length > 0) profilePercentage.value += 12;
    if (profileImage.value != null || image.value.length > 4)
      profilePercentage.value += 28;

    profilePercentage.refresh();
  }

  Future<void> updateUser() async {
    Pattern _emailPattern =
    // r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    // Pattern vehicleNumPattern = "[A-Z]{2}[0-9]{2}[A-Z]{2}[0-9]{4}";
    Pattern vehicleNumPattern = "[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{4}"; //updated on 7/06/2022


    load.value=true;

    if (!RegExp(vehicleNumPattern.toString()).hasMatch(bikenumber.value)) {
      Get.bottomSheet(ErrorAlert(
        message: "Please enter valid vehicle number format".tr,
        onClose: () {
          Get.back();
        },
      ));
      load.value = false;
    }
    else if(!RegExp(_emailPattern.toString()).hasMatch(email.value))
    {
      Get.bottomSheet(ErrorAlert(
        message: "Please enter valid Email".tr,
        onClose: () {
          Get.back();
        },
      ));
      load.value = false;
    }else{

      load.value = true;
      Map<String, dynamic> data = await updateUserRequest(
        user.value!.id!,
        name.value,
        surname.value,
        bikenumber.value,
        phone.value,
        email.value,
        "",
        // newPassword.value.length > 0
        //     ? newPassword.value
        //     : currentPassword.value,
        image.value,
        gender.value,
      );

      if (data['success']) {
        Users userOld = user.value!;
        Users updatedUser = Users(
            id: userOld.id,
            name: name.value,
            surname: surname.value,
            bikenumber: bikenumber.value,
            password: newPassword.value.length > 0
                ? newPassword.value
                : currentPassword.value,
            gender: gender.value,
            phone: phone.value,
            imageUrl: image.value,
            email: email.value);

        user.value = updatedUser;
        load.value = false;

        Get.bottomSheet(SuccessAlert(
          message: "Successfully updated".tr,

          onClose: () {
            // Get.toNamed("/location");
          },
        ));

        Future.delayed(Duration(seconds: 1),() async {
          Get.toNamed("/location");
        });

        final box = GetStorage();
        box.write('user', updatedUser.toJson());
      }
    }
  }

}
