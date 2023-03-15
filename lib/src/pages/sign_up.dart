import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samku/src/models/model_vehicleModel.dart';

import '/src/components/password_input.dart';
import '/src/components/sign_button.dart';
import '/src/components/text_input.dart';
import '/src/controllers/sign_up_controller.dart';
import '../models/manufacture_model.dart';

class SignUpPage extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  final SignUpController controller = Get.put(SignUpController());
  Data? _manufactureSelected, vehicleTypeSelected;
  Model? vehicleModelSelected;
  bool flagSignUp = false;

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
          child: Column(children: <Widget>[
            Container(
                width: 1.sw,
                height: 25,
                margin: EdgeInsets.only(top: 0.075.sh, right: 16, left: 30),
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset("lib/assets/images/samkuEV.png"),
                    InkWell(
                      onTap: () {
                        Get.toNamed("/signin");
                      },
                      child: Text(
                        "Sign In".tr,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 18.sp,
                            letterSpacing: -1,
                            color: Color.fromRGBO(69, 165, 36, 1)),
                      ),
                    ),
                  ],
                )),
              SizedBox(height: 10.0,),
              Container(
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
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Sign Up".tr,
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

                              Column(
                                children: [
                                  TextInput(
                                    title: "Name *".tr,
                                    placeholder: "Joe",
                                    defaultValue: controller.name.value,
                                    onChange: controller.onChangeName,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  TextInput(
                                    title: "Surname *".tr,
                                    placeholder: "Antonio",
                                    defaultValue: controller.surname.value,
                                    onChange: controller.onChangeSurname,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  // TextInput(
                                  //   title: "Car/Bike Name*".tr,
                                  //   placeholder: "Antonio",
                                  //   defaultValue: controller.bikeName.value,
                                  //   onChange: controller.onChangeBikeName,
                                  // ),
                                  // Divider(
                                  //   color: Get.isDarkMode
                                  //       ? Color.fromRGBO(255, 255, 255, 1)
                                  //       : Color.fromRGBO(0, 0, 0, 1),
                                  //   height: 1,
                                  // ),
                                  TextInput(
                                    title: "Vehicle Number".tr,
                                    placeholder: "Antonio",
                                     textCapital: TextCapitalization.characters,
                                    defaultValue: controller.bikenumber.value,
                                    onChange: controller.onChangeBikeNumber,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  //manufacture
                                  // FutureBuilder<List<Data>>(
                                  //   future: fetchManufactVehicleTye("/get_oems"),
                                  //   builder: (BuildContext context,
                                  //       AsyncSnapshot<List<Data>> snapshot) {
                                  //     if (!snapshot.hasData)
                                  //       return Container();
                                  //
                                  //     return Column(
                                  //       mainAxisAlignment: MainAxisAlignment.start,
                                  //       crossAxisAlignment: CrossAxisAlignment.start,
                                  //       children: [
                                  //         Container(
                                  //             margin: EdgeInsets.only(
                                  //               top: 10.0,
                                  //             ),
                                  //             child:Text("Manufacture",style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500,
                                  //                 fontFamily: "Inter"))),
                                  //         DropdownButtonHideUnderline(
                                  //             child:
                                  //             Container(
                                  //                 margin: EdgeInsets.only(
                                  //                   top: 5.0,
                                  //                 ),
                                  //
                                  //                 child: DropdownButton(
                                  //                   hint: Padding(
                                  //                       padding: EdgeInsets.all(15.0),
                                  //                       child: Text(
                                  //                         'Manufacture',
                                  //                         style: TextStyle(
                                  //                             fontWeight: FontWeight.w400,
                                  //                             fontSize: 14.0,
                                  //                             color: Colors.black45,
                                  //                             fontFamily: 'Inter'),
                                  //                       )),
                                  //                   isExpanded: true,
                                  //                   iconSize: 30.0,
                                  //                   style: TextStyle(fontWeight: FontWeight.w400,
                                  //                       fontSize: 14.0,
                                  //                       color: Colors.black45,
                                  //                       fontFamily: 'Inter'),
                                  //                   items: snapshot.data!.map((manufacture) =>
                                  //                       DropdownMenuItem<Data>(
                                  //                         value: manufacture,
                                  //                         child: Padding(
                                  //                             padding:
                                  //                             EdgeInsets.only(
                                  //                                 left: 15.0),
                                  //                             child: Text(
                                  //                               manufacture.name.toString(),
                                  //                               style: TextStyle(
                                  //                                   color:
                                  //                                   Colors.black,
                                  //                                   fontSize: 14.0,
                                  //                                   fontWeight:
                                  //                                   FontWeight
                                  //                                       .w500,
                                  //                                   fontFamily:
                                  //                                   'Inter'),
                                  //                             )),
                                  //                       ))
                                  //                       .toList(),
                                  //                   value: controller.manufactureSelected == null ? controller.manufactureSelected : snapshot.data!.where((i) =>
                                  //                   i.name ==controller.manufactureSelected!.name).first as Data,
                                  //                   onChanged: (manufacture) {
                                  //                     setState(
                                  //                           () {
                                  //                             controller.manufactureSelected = manufacture;
                                  //                             controller.vehicleModelSelected=null;
                                  //
                                  //                       },
                                  //                     );
                                  //                   },
                                  //                 ))),
                                  //         Divider(
                                  //           color: Get.isDarkMode
                                  //               ? Color.fromRGBO(255, 255, 255, 1)
                                  //               : Color.fromRGBO(0, 0, 0, 1),
                                  //           height: 1,
                                  //         ),
                                  //
                                  //       ],
                                  //     );
                                  //   },
                                  // ),
                                  // //vehicle type
                                  // FutureBuilder<List<Data>>(
                                  //   future:
                                  //   fetchManufactVehicleTye("/get_vehicle_types"),
                                  //   builder: (BuildContext context,
                                  //       AsyncSnapshot<List<Data>> snapshot) {
                                  //     if (!snapshot.hasData) return Container();
                                  //
                                  //     return Column(
                                  //       mainAxisAlignment:
                                  //       MainAxisAlignment.start,
                                  //       crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //       children: [
                                  //         Container(
                                  //             margin: EdgeInsets.only(
                                  //               top: 10.0,
                                  //             ),
                                  //             child: Text("Vehicle Type",
                                  //                 style: TextStyle(
                                  //                     fontSize: 16.0,
                                  //                     fontWeight:
                                  //                     FontWeight.w500,
                                  //                     fontFamily: "Inter"))),
                                  //         DropdownButtonHideUnderline(
                                  //             child: Container(
                                  //                 margin: EdgeInsets.only(
                                  //                   top: 5.0,
                                  //                 ),
                                  //                 child: DropdownButton(
                                  //                   hint: Padding(
                                  //                       padding: EdgeInsets.all(
                                  //                           15.0),
                                  //                       child: Text(
                                  //                         'Vehicle Type',
                                  //                         style: TextStyle(
                                  //                             fontWeight:
                                  //                             FontWeight
                                  //                                 .w400,
                                  //                             fontSize: 14.0,
                                  //                             color: Colors
                                  //                                 .black45,
                                  //                             fontFamily:
                                  //                             'Inter'),
                                  //                       )),
                                  //                   isExpanded: true,
                                  //                   iconSize: 30.0,
                                  //                   style: TextStyle(
                                  //                       fontWeight:
                                  //                       FontWeight.w400,
                                  //                       fontSize: 14.0,
                                  //                       color: Colors.black45,
                                  //                       fontFamily: 'Inter'),
                                  //                   items: snapshot.data!
                                  //                       .map((vehicleType) =>
                                  //                       DropdownMenuItem<
                                  //                           Data>(
                                  //                         value:
                                  //                         vehicleType,
                                  //                         child: Padding(
                                  //                             padding: EdgeInsets
                                  //                                 .only(
                                  //                                 left:
                                  //                                 15.0),
                                  //                             child: Text(
                                  //                               vehicleType
                                  //                                   .name
                                  //                                   .toString(),
                                  //                               style: TextStyle(
                                  //                                   color: Colors
                                  //                                       .black,
                                  //                                   fontSize:
                                  //                                   14.0,
                                  //                                   fontWeight:
                                  //                                   FontWeight
                                  //                                       .w500,
                                  //                                   fontFamily:
                                  //                                   'Inter'),
                                  //                             )),
                                  //                       ))
                                  //                       .toList(),
                                  //                   value: controller.vehicleTypeSelected ==
                                  //                       null
                                  //                       ? controller.vehicleTypeSelected
                                  //                       : snapshot.data!
                                  //                       .where((i) =>
                                  //                   i.name ==
                                  //                       controller.vehicleTypeSelected!
                                  //                           .name)
                                  //                       .first as Data,
                                  //                   onChanged:
                                  //                       (vehicleType) {
                                  //                     setState(
                                  //                           () {
                                  //                             controller.vehicleTypeSelected = vehicleType;
                                  //                             controller.vehicleModelSelected=null;
                                  //                             // fetchVehicleModel(controller.manufactureSelected, controller.vehicleTypeSelected);
                                  //                             },
                                  //                     );
                                  //                   },
                                  //                 ))),
                                  //         Divider(
                                  //           color: Get.isDarkMode
                                  //               ? Color.fromRGBO(
                                  //               255, 255, 255, 1)
                                  //               : Color.fromRGBO(0, 0, 0, 1),
                                  //           height: 1,
                                  //         ),
                                  //       ],
                                  //     );
                                  //   },
                                  // ),
                                  //
                                  // //model
                                  // FutureBuilder<List<Model>>(
                                  //   future: fetchVehicleModel(
                                  //       controller.manufactureSelected,
                                  //       controller.vehicleTypeSelected),
                                  //   builder: (BuildContext context,
                                  //       AsyncSnapshot<List<Model>> snapshot) {
                                  //     if (!snapshot.hasData) return Container();
                                  //
                                  //     return Column(
                                  //       mainAxisAlignment:
                                  //       MainAxisAlignment.start,
                                  //       crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //       children: [
                                  //         Container(
                                  //             margin: EdgeInsets.only(
                                  //               top: 10.0,
                                  //             ),
                                  //             child: Text("Model",
                                  //                 style: TextStyle(
                                  //                     fontSize: 16.0,
                                  //                     fontWeight:
                                  //                     FontWeight.w500,
                                  //                     fontFamily: "Inter"))),
                                  //         DropdownButtonHideUnderline(
                                  //             child: Container(
                                  //                 margin: EdgeInsets.only(
                                  //                   top: 5.0,
                                  //                 ),
                                  //                 child: DropdownButton(
                                  //                   hint: Padding(
                                  //                       padding: EdgeInsets.all(
                                  //                           15.0),
                                  //                       child: Text(
                                  //                         'Vehicle Model',
                                  //                         style: TextStyle(
                                  //                             fontWeight:
                                  //                             FontWeight
                                  //                                 .w400,
                                  //                             fontSize: 14.0,
                                  //                             color: Colors
                                  //                                 .black45,
                                  //                             fontFamily:
                                  //                             'Inter'),
                                  //                       )),
                                  //                   isExpanded: true,
                                  //                   iconSize: 30.0,
                                  //                   style: TextStyle(
                                  //                       fontWeight:
                                  //                       FontWeight.w400,
                                  //                       fontSize: 14.0,
                                  //                       color: Colors.black45,
                                  //                       fontFamily: 'Inter'),
                                  //                   items: snapshot.data!
                                  //                       .map((model) =>
                                  //                       DropdownMenuItem<
                                  //                           Model>(
                                  //                         value: model,
                                  //                         child: Padding(
                                  //                             padding: EdgeInsets
                                  //                                 .only(
                                  //                                 left:
                                  //                                 15.0),
                                  //                             child: Text(
                                  //                               model
                                  //                                   .modelName
                                  //                                   .toString(),
                                  //                               style: TextStyle(
                                  //                                   color: Colors
                                  //                                       .black,
                                  //                                   fontSize:
                                  //                                   14.0,
                                  //                                   fontWeight:
                                  //                                   FontWeight
                                  //                                       .w500,
                                  //                                   fontFamily:
                                  //                                   'Inter'),
                                  //                             )),
                                  //                       ))
                                  //                       .toList(),
                                  //                   value:controller.vehicleModelSelected ==
                                  //                       null
                                  //                       ? controller.vehicleModelSelected
                                  //                       : snapshot.data!
                                  //                       .where((i) =>
                                  //                   i.modelName ==
                                  //                       controller.vehicleModelSelected!
                                  //                           .modelName)
                                  //                       .first as Model,
                                  //                   onChanged: (model) {
                                  //                     setState(
                                  //                           () {
                                  //                         controller.vehicleModelSelected = model;
                                  //                         print(
                                  //                             controller.vehicleModelSelected);
                                  //                       },
                                  //                     );
                                  //                   },
                                  //                 ))),
                                  //         Divider(
                                  //           color: Get.isDarkMode
                                  //               ? Color.fromRGBO(
                                  //               255, 255, 255, 1)
                                  //               : Color.fromRGBO(0, 0, 0, 1),
                                  //           height: 1,
                                  //         ),
                                  //         //           SizedBox(
                                  //         //             height: 3.0,
                                  //         //           ),
                                  //         //           Text(
                                  //         //             vehicleModelSelected == null && flagSignUp==true
                                  //         //                 ? "Please select Vehicle Model"
                                  //         //                 : "",
                                  //         //             style: TextStyle(
                                  //         //                 fontWeight: FontWeight.w400,
                                  //         //                 fontSize: 12.0,
                                  //         //                 fontFamily: 'Inter',
                                  //         //                 color: Theme
                                  //         //                     .of(context)
                                  //         //                     .errorColor),
                                  //         // //           )
                                  //       ],
                                  //     );
                                  //   },
                                  // ),
                                  // TextInput(
                                  //   title: "Model Number".tr,
                                  //   placeholder: "Antonio",
                                  //   defaultValue: controller.modelnumber.value,
                                  //   onChange: controller.onChangeModelNumber,
                                  // ),
                                  // Divider(
                                  //   color: Get.isDarkMode
                                  //       ? Color.fromRGBO(255, 255, 255, 1)
                                  //       : Color.fromRGBO(0, 0, 0, 1),
                                  //   height: 1,
                                  // ),
                                  TextInput(
                                    title: "Email Id".tr,
                                    placeholder: "Antonio",
                                    defaultValue: controller.email.value,
                                    onChange: controller.onChangeEmail,
                                  ),
                                  Divider(
                                    color: Get.isDarkMode
                                        ? Color.fromRGBO(255, 255, 255, 1)
                                        : Color.fromRGBO(0, 0, 0, 1),
                                    height: 1,
                                  ),
                                  TextInput(
                                      title: "Phone number *".tr,
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
                                  // PasswordInput(
                                  //   title: "Password *".tr,
                                  //   onChange: controller.onChangePassword,
                                  // ),
                                  // Divider(
                                  //   color: Get.isDarkMode
                                  //       ? Color.fromRGBO(255, 255, 255, 1)
                                  //       : Color.fromRGBO(0, 0, 0, 1),
                                  //   height: 1,
                                  // ),
                                  // PasswordInput(
                                  //   title: "Confirm Password".tr,
                                  //   onChange:
                                  //       controller.onChangePasswordConfirm,
                                  // ),
                                ],
                              ),

                        SizedBox(
                          height: 0.04.sh,
                        ),
                        SignButton(
                          title: "Sign Up".tr,
                          loading: controller.loading.value,
                          onClick: controller.signUpWithPhone,
                        )
                      ],
                    );
                  })),

          ]),
        ),
      ),
    );
  }
}
