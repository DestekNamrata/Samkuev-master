import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '/src/components/error_dialog.dart';
import '/src/components/success_alert.dart';
import '/src/controllers/auth_controller.dart';
import '/src/models/user.dart';
import '/src/requests/sign_in_request.dart';

class SignInController extends GetxController {
  var loading = false.obs;
  var loadingSocial = false.obs;
  var error = "";
  var password = "".obs;
  var phone = "".obs;
  var code = "".obs;
  var verificationId = "".obs;
  AuthController authController = Get.put(AuthController());

  // Future<void> signInWithSocial(String socialId) async {
  //   loadingSocial.value = true;

  //   Map<String, dynamic> data = await signInRequest(
  //       phone.value, password.value, authController.token.value);
  //   if (data['success'] != null) {
  //     if (data['success']) {
  //       String name = data['data']['name'];

  //       Get.bottomSheet(SuccessAlert(
  //         message: "${"Welcome".tr} $name",
  //         onClose: () {
  //           Get.back();
  //         },
  //       ));

  //       setUser(data['data']);
  //       Future.delayed(1.seconds, () async {
  //         authController.getUserInfoAndRedirect();
  //       });
  //     } else {
  //       Get.bottomSheet(ErrorAlert(
  //         message: "No client found in system".tr,
  //         onClose: () {
  //           Get.back();
  //         },
  //       ));
  //     }
  //   } else if (data['error'] != null) {
  //     Get.bottomSheet(ErrorAlert(
  //       message: "Error occured in login".tr,
  //       onClose: () {
  //         Get.back();
  //       },
  //     ));
  //   }

  //   loadingSocial.value = false;
  // }
  Future<void> VerifyWithPhone() async {
    loading.value = true;
     if (phone.value.length < 9) {
       Get.bottomSheet(ErrorAlert(
         message: "Phone length should be at least 10 characters".tr,
         onClose: () {
           Get.back();
         },
       ));
       loading.value = false;
     }else {
       print(
           "------------------------------------------------\n my number ${phone
               .value}");
       await FirebaseAuth.instance.verifyPhoneNumber(
         phoneNumber: "+91${phone.value}",
         verificationCompleted: (PhoneAuthCredential credential) {},
         verificationFailed: (FirebaseAuthException e) {
           loading.value = false;
           if (e.code == 'invalid-phone-number') {
             Get.bottomSheet(ErrorAlert(
               message: "Phone number is not valid".tr,
               onClose: () {
                 Get.back();
               },
             ));
           }
         },
         codeSent: (String vId, int? resendToken) {
           loading.value = false;
           verificationId.value = vId;
           Get.toNamed("/verifyPhone",
               arguments: {
                 "phone": phone.value,
                 "flagVerify": "0"
               }); //from signIn
         },
         codeAutoRetrievalTimeout: (String verificationId) {},
       );
     }
  }


  Future<void> signInWithPhone() async {
    loading.value = true;

    Map<String, dynamic> data = await signInRequest(
        phone.value, password.value, authController.token.value);

    if (data['success'] != null) {
      if (data['success']) {
        String name = data['data']['name'];
        Get.bottomSheet(SuccessAlert(
          message: "${"Welcome".tr} $name",
          onClose: () {
            Get.back();
          },
        ));
        setUser(data['data']);
        Future.delayed(1.seconds, () async {
          authController.getUserInfoAndRedirect();
        });
      }
      else {
        // Get.bottomSheet(ErrorAlert(
        //   message: "Email or password wrong".tr,
        //   onClose: () {
        //     Get.back();
        //   },
        // ));

        Get.bottomSheet(ErrorAlert(
          // message: data['message'],
          message: "User does not exists",
          onClose: () {
            Get.back();
          },
        ));
      }
    }

    else if (data['error'] != null) {
      Get.bottomSheet(ErrorAlert(
        message: "Error occured in login".tr,
        onClose: () {
          Get.back();
        },
      ));
    }
    loading.value = false;
  }

  void onChangePhone(String text) {
    if (text.length > 1) phone.value = text;

    // if (phone.value.length == 0) phone.value = "";
    // if (phone.value[0] != "+") phone.value = "${phone.value}";
  }

  void onChangePassword(String text) {
    password.value = text;
  }

  void setUser(Map<String, dynamic> data) {
    String name = data['name'];
    String surname = data['surname'];
    String phone = data['phone'] != null ? data['phone'] : "";
    String imageUrl = data['image_url'] != null && data['image_url'].length > 4
        ? data['image_url']
        : "";
    int id = data['id'];
    String email = data['email'] != null ? data['email'] : "";
    String token = data['token'] != null ? data['token'] : "";
    String bikenumber = data['vehicle_number'] != null ? data['vehicle_number'] : "";
    String bikeName = data['bikeName'] != null ? data['bikeName'] : "";
    String modelnumber = data['modelnumber'] != null ? data['modelnumber'] : "";

    Users user = Users(
      name: name,
      surname: surname,
      phone: phone,
      imageUrl: imageUrl,
      id: id,
      email: email,
      token: token,
      bikenumber: bikenumber,
      bikeName: bikeName,
      modelnumber: modelnumber,
    );

    authController.user.value = user;
    authController.user.refresh();

    final box = GetStorage();
    box.write('user', user.toJson());
  }
}
