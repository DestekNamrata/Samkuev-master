import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:samku/src/models/BrandsModel.dart';
import 'package:samku/src/models/manufacture_model.dart';

import '/src/components/error_dialog.dart';
import '/src/components/success_alert.dart';
import '/src/controllers/auth_controller.dart';
import '/src/models/user.dart' as UserModel;
import '/src/requests/sign_up_request.dart';

class SignUpController extends GetxController {
  var loading = false.obs;
  var loadingSocial = false.obs;
  var error = "";
  var password = "".obs;
  var passwordConfirm = "".obs;
  var phone = "".obs;
  var name = "".obs;
  var surname = "".obs;
  var bikeName = "".obs;
  var bikenumber = "".obs;
  var modelnumber = "".obs;
  var email = "".obs;
  var code = "".obs;
  var verificationId = "".obs;
  var manufactureSelected, vehicleTypeSelected, vehicleModelSelected;
  AuthController authController = Get.put(AuthController());
  StreamController<ErrorAnimationType>? errorController;

  @override
  void dispose() {
    errorController?.close();
    super.dispose();
  }

  // Future<void> signUpWithSocial(
  //     String socialId, String name, String email, String photoUrl) async {
  //   loadingSocial.value = true;

  //   int index = name.indexOf(" ");
  //   String firstName = index > -1 ? name.substring(0, index).trim() : name;
  //   String surname = index > -1 && name.substring(index).length > 0
  //       ? name.substring(index)
  //       : name;

  //   Map<String, dynamic> data = await signUpRequest(firstName, surname, "",
  //       email, "", 2, socialId, authController.token.value);

  //   if (data['success'] != null) {
  //     if (data['success']) {
  //       Get.bottomSheet(SuccessAlert(
  //         message: "Successfully registered".tr,
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
  //         message: "You are already registered".tr,
  //         onClose: () {
  //           Get.back();
  //         },
  //       ));
  //     }
  //   } else if (data['error'] != null) {
  //     Get.bottomSheet(ErrorAlert(
  //       message: "Error occured in registration".tr,
  //       onClose: () {
  //         Get.back();
  //       },
  //     ));
  //   }

  //   loadingSocial.value = false;
  // }


  Future<void> signUpWithPhone() async {
    Pattern _emailPattern =
        // r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    // Pattern vehicleNumPattern = "[A-Z]{2}[0-9]{2}[A-Z]{2}[0-9]{4}";
    Pattern vehicleNumPattern = "[A-Z]{2}[0-9]{1,2}[A-Z]{1,2}[0-9]{4}"; //updated on 7/06/2022

    loading.value = true;
    if (name.value.isEmpty) {
      Get.bottomSheet(ErrorAlert(
        message: "Enter your name".tr,
        onClose: () {
          Get.back();
        },
      ));
      loading.value = false;
    } else if (surname.value.isEmpty) {
      Get.bottomSheet(ErrorAlert(
        message: "Enter your surname".tr,
        onClose: () {
          Get.back();
        },
      ));
      loading.value = false;

      // // } else if (bikeName.value.length < 4) {
      // //   Get.bottomSheet(ErrorAlert(
      // //     message: "Bike Name length should be at least 4 characters".tr,
      // //     onClose: () {
      // //       Get.back();
      // //     },
      // //   ));
      // //   loading.value = false;
      } else if (!RegExp(vehicleNumPattern.toString()).hasMatch(bikenumber.value)) {
      Get.bottomSheet(ErrorAlert(
      message: "Please enter valid vehicle number format".tr,
      onClose: () {
      Get.back();
      },
      ));
      loading.value = false;
      // // } else if (modelnumber.value.length < 4) {
      // //   Get.bottomSheet(ErrorAlert(
      // //     message: "Model Number length should be at least 4 characters".tr,
      // //     onClose: () {
      // //       Get.back();
      // //     },
      // //   ));
      // //   loading.value = false;
      // } else if (manufactureSelected==null) {
      // Get.bottomSheet(ErrorAlert(
      // message: "Please select Manufacture".tr,
      // onClose: () {
      // Get.back();
      // },
      // ));
      // loading.value = false;
      // } else if (vehicleTypeSelected==null) {
      // Get.bottomSheet(ErrorAlert(
      // message: "Please select Vehicle Type".tr,
      // onClose: () {
      // Get.back();
      // },
      // ));
      // loading.value = false;
      // }else if (vehicleModelSelected==null) {
      // Get.bottomSheet(ErrorAlert(
      // message: "Please select Vehicle Model".tr,
      // onClose: () {
      // Get.back();
      // },
      // ));
      // loading.value = false;
      // } else

    }else if(!RegExp(_emailPattern.toString()).hasMatch(email.value))
      {
        Get.bottomSheet(ErrorAlert(
          message: "Please enter valid Email".tr,
          onClose: () {
            Get.back();
          },
        ));
        loading.value = false;
  }
    else if (phone.value.length < 9) {
      Get.bottomSheet(ErrorAlert(
        message: "Phone length should be at least 10 characters".tr,
        onClose: () {
          Get.back();
        },
      ));
      loading.value = false;
    // } else if (password.value.length < 6) {
    //   Get.bottomSheet(ErrorAlert(
    //     message: "Password length should be at least 6 characters".tr,
    //     onClose: () {
    //       Get.back();
    //     },
    //   ));
    //   loading.value = false;
    // } else if (password.value != passwordConfirm.value) {
    //   Get.bottomSheet(ErrorAlert(
    //     message: "Password and confirm password mismatch".tr,
    //     onClose: () {
    //       Get.back();
    //     },
    //   ));
    //   loading.value = false;
    }
    else {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${phone.value}',
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          loading.value = false;
          if (e.code == 'invalid-phone-number') {
            Get.bottomSheet(ErrorAlert(
              message: "Phone number is not valid".tr,
              onClose: () {
                loading.value = false;
                Get.back();
              },
            ));
          }
        },
        codeSent: (String vId, int? resendToken) {
          loading.value = false;
          verificationId.value = vId;
          Get.offAndToNamed("/verifyPhone",
              arguments: {
            "flagVerify": "1"
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    }
  }

  Future<void> confirmSignUpWithPhone() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value, smsCode: code.value);

    print("-----------------verificationId" + verificationId.value);
    print("-----------------code" + code.value);
    try {
      UserCredential userData =
          await FirebaseAuth.instance.signInWithCredential(credential);
      print(userData.toString());
      if (userData.user != null) {
        Map<String, dynamic> data = await signUpRequest(
            name.value,
            surname.value,
            bikeName.value,
            bikenumber.value,
            modelnumber.value,
            email.value,
            phone.value,
            // password.value,
            "",
            1,
            "",
            authController.token.value,
            manufactureSelected != null
                ? manufactureSelected.id.toString()
                : "",
            vehicleTypeSelected != null
                ? vehicleTypeSelected.id.toString()
                : "",
            vehicleTypeSelected != null
                ? vehicleModelSelected.id.toString()
                : "");
        print("data:" + data.toString());
        // Map<String, dynamic> data = await signUpRequest(
        //     name,
        //     surname,
        //    "",
        //     vehicleNumber,
        //     "",
        //     emailId,
        //     phone,
        //     pwd,
        //
        //     1,
        //     "",
        //     authController.token.value,
        //    manufactId,
        //     vehicleTypeId,modelId);
        if (data['success'] != null) {
          if (data['success']) {
            Get.bottomSheet(SuccessAlert(
              message: "Successfully registered".tr,
              onClose: () {
                // Get.toNamed("/location");
                Get.back();
              },
            ));

            setUser(data['data']);
            Future.delayed(1.seconds, () async {
              authController.getUserInfoAndRedirect();
            });
          } else {
            Get.bottomSheet(ErrorAlert(
              message: "You are already registered".tr,
              onClose: () {
                // Get.toNamed("/location");
                Get.back();
              },
            ));
          }
        } else {
          Get.bottomSheet(ErrorAlert(
            message: "Error occured in registration",
            onClose: () {
              Get.back();
            },
          ));
        }
      }
    } catch (e) {
      Get.bottomSheet(ErrorAlert(
        message: "Sms code is invalid".tr,
        onClose: () {
          Get.back();
        },
      ));
    }
  }

  Future<void> confirmSignUpWithPhoneForForgetpwd() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId.value, smsCode: code.value);
    print("-----------------verificationId" + verificationId.value);
    print("-----------------code" + code.value);
    try {
      // UserCredential userData =
      // await FirebaseAuth.instance.signInWithCredential(credential);
      // print(userData.toString());
      // if (userData.user != null) {
      // Map<String, dynamic> data = await signUpRequest(
      //     name.value,
      //     surname.value,
      //     bikeName.value,
      //     bikenumber.value,
      //     modelnumber.value,
      //     email.value,
      //     phone.value,
      //     password.value,
      //     1,
      //     "",
      //     authController.token.value);
      // if (data['success'] != null) {
      //   if (data['success']) {
      //     Get.bottomSheet(SuccessAlert(
      //       message: "Enter Successfully".tr,
      //       onClose: () {
      //         Get.toNamed("/location");
      //         // Get.back();
      //       },
      //     ));
      //     Get.bottomSheet(ErrorAlert(
      //       message: "You are not registered".tr,
      //       onClose: () {
      //         // Get.toNamed("/location");
      //         Get.back();
      //       },
      //     ));
      //     setUser(data['data']);
      //     Future.delayed(1.seconds, () async {
      //       authController.getUserInfoAndRedirect();
      //     });
      //   } else {
      Get.bottomSheet(SuccessAlert(
        message: "Enter Successfully".tr,
        onClose: () {
          Get.toNamed("/location");
          // Get.back();
        },
      ));

      //   }
      // } else {
      //   Get.bottomSheet(ErrorAlert(
      //     message: "Error occured in registration",
      //     onClose: () {
      //       Get.back();
      //     },
      //   ));
      // }
      // }
    } catch (e) {
      Get.bottomSheet(ErrorAlert(
        message: "Sms code is invalid".tr,
        onClose: () {
          Get.back();
        },
      ));
    }
  }

  void onChangeName(String text) {
    name.value = text;
  }

  void onChangeSurname(String text) {
    surname.value = text;
  }

  void onChangeBikeName(String text) {
    bikeName.value = text;
  }

  void onChangeBikeNumber(String text) {
    bikenumber.value = text;
  }
  // void isValidNumber(String number){
  //   if (!RegExp(vehicleNumPattern.toString()).hasMatch(bikenumber.value)){
  //     return true;
  //   }
  //   else {
  //     return false;
  //   }
  // }

  void onChangeModelNumber(String text) {
    modelnumber.value = text;
  }


  void onChangeEmail(String text) {
    email.value = text;
  }

  void onChangePhone(String text) {
    if (text.length > 1) phone.value = text;

    // if (phone.value.length == 0) phone.value = "";
    // if (phone.value[0] != "+") phone.value = "${phone.value}";
  }

  void onChangePassword(String text) {
    password.value = text;
  }

  void onChangePasswordConfirm(String text) {
    passwordConfirm.value = text;
  }

  void onChangeSmsCode(String text) {
    code.value = text;
  }

  void setUser(Map<String, dynamic> data) {
    String name = data['name'];
    String surname = data['surname'];
    String phone = data['phone'] ?? "";
    String imageUrl = data['image_url'] ?? "";
    int id = data['id'];
    String email = data['email'] ?? "";
    String token = data['token'];
    String bikenumber = data['vehicle_number'];

    UserModel.Users user = UserModel.Users(
        name: name,
        surname: surname,
        phone: phone,
        imageUrl: imageUrl,
        id: id,
        bikenumber: bikenumber,
        email: email,
        token: token);


    authController.user.value = user;


    authController.user.refresh();

    final box = GetStorage();
    box.write('user', user.toJson());
  }

  Future<void> resetPasswordWithPhone() async {
    loading.value = true;
    print(
        "------------------------------------------------\n my number ${phone.value}");
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
        Get.toNamed("/verifyPhoneforForgetPWD",
            arguments: {"phone": phone.value});
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }
}
