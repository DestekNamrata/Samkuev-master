import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:samku/src/components/card_item.dart';
import 'package:samku/src/components/checkout_head.dart';
import 'package:samku/src/controllers/auth_controller.dart';
import 'package:samku/src/controllers/cart_controller.dart';
import 'package:samku/src/pages/timer.dart';

import 'dart:convert';

import '/config/global_config.dart';
import 'package:http/http.dart' as http;

class PaymentMethod extends StatefulWidget {
  var startTime, endTime, date, productId, duration, flag;
  var name,chargingType,imageUrl,tax;
  double? totalAmt,amount;

  PaymentMethod(
      {Key? key,
      @required this.startTime,
      @required this.endTime,
      @required this.date,
      @required this.productId,
      @required this.amount,
      @required this.duration,
      @required this.flag,
      @required this.name,
      @required this.imageUrl,
      @required this.chargingType,
      @required this.totalAmt,
      @required this.tax})
      : super(key: key);

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  CartController cartController = CartController();
  Razorpay? _razorpay;
  String paymentId = "";
  var razorPayKey = 'rzp_test_5Iy4UkUkWSt7Db', //test:-given by sachin
      razorPaySecretKey = 'imvl6mdmdCI2Oa4Er6fXCgQW';
  bool _value = false;
  int val = -1;
  final AuthController authController = Get.put(AuthController());
  // var user = Rxn<User>();
  User? user;
  bool loading=false;
  bool proceed=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cartController = CartController();

    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
    paymentId = response.paymentId.toString();
    doPayment();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Fluttertoast.showToast(
    //     msg: "ERROR: " +
    //         response.code.toString() +
    //         " - " +
    //         response.message.toString(),
    //     toastLength: Toast.LENGTH_SHORT);
    Fluttertoast.showToast(
        msg: "Payment has been cancelled",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName.toString(),
        toastLength: Toast.LENGTH_SHORT);
  }

  //for checkout optios
  void openCheckout() async {
    // double amt=(cartController.calculateAmount()+cartController.calculateDiscount())*100;

    var phone = cartController.authController.phone.toString();

    double amt = (double.parse(widget.totalAmt!.toStringAsFixed(2))) * 100;
    print("amt:-" + amt.toString());
    var options = {
      'key': razorPayKey,
      'amount': amt,
      // 'amount':100,
      'name': 'Samku',
      // 'order_ID':widget.productId,
      // 'description': widget.cartDet[0].producerName,
      'prefill': {
        'contact': cartController.authController.phone.toString(),
        'email': cartController.authController.email.toString()
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  //called method for payment
  void doPayment() async {
    await cartController
        .orderSave(widget.startTime, widget.endTime, widget.date,
            widget.productId.toString(), double.parse(widget.totalAmt!.toStringAsFixed(2)),widget.duration.toString(),widget.tax.toString())
        .whenComplete(() {

      _showMessage();
    });
  }

  //for onTap of yes of connected charger
  Future<void> chargerConnected(int orderId) async{
    // String url = "$GLOBAL_URL/client/order/chargerconnected?id="+orderId.toString();
    String url="https://samku.ezii.live/api/order/chargerconnected?id="+orderId.toString();

    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    // Map<String, String> body = {
    //   "id": orderId.toString(),
    // };
    final client = new http.Client();
    // final response = await client.post(Uri.parse(url),
    //     headers: headers, body: json.encode(body));
    final response = await client.get(Uri.parse(url));

    // print(body);
    // print(response.body);sh

    Map<String, dynamic> responseJson = {};

    try {
      if (response.statusCode == 200) {
        // var repencode=json.encode(response.body);
        var responseJson = json.decode(response.body);
        print(responseJson);
        if(responseJson['success']==true) {
          Future.delayed(Duration(seconds: 10), () {
            setState(() {
              proceed=true;
              loading = false;
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>TimerScreen(
              amount: widget.amount,
              duration: widget.duration.toString(),
              paymentType: cartController.paymentType.value.toString(),
              date: widget.date,
              name: cartController.type.toString(),
              port: cartController.port.toString(),
              totalAmt: widget.totalAmt,
              tax: widget.tax.toString(),
              imageUrl: widget.imageUrl,
              chargingType: widget.chargingType,

            )));
            // Get.to(TimerScreen(
            //   amount: widget.amount.toString(),
            //   duration: widget.duration.toString(),
            //   paymentType: cartController.paymentType.value.toString(),
            //   date: widget.date,
            //   name: cartController.type.toString(),
            //   port: cartController.port.toString(),
            //   totalAmt: widget.totalAmt.toString(),
            //   tax: widget.tax.toString(),
            //   imageUrl: widget.imageUrl,
            //   chargingType: widget.chargingType,
            //
            // ));
          });
        }else{
          setState(() {
            loading = false;
          });
        }
      }else{
        setState(() {
          loading = false;
        });
      }

    } on FormatException catch (e) {
      print(e);
    }


  }


  Future<void> _showMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Payment",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Payment done successfully.",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "OK",
              ),
              onPressed: () {
                if (widget.flag == "prebook") {
                  Get.offAndToNamed("/location");
                } else {
                  //Get.offAndToNamed("/TimerScreen");
                  _showChargerMessage(cartController.orderId.value);

                  // Get.to(TimerScreen(
                  //   amount: widget.amount.toString(),
                  //   duration: widget.duration.toString(),
                  //   paymentType: cartController.paymentType.value.toString(),
                  //   date: widget.date,
                  //   name: cartController.type.toString(),
                  //   port: cartController.port.toString(),
                  //   totalAmt:widget.totalAmt.toString(),
                  //   tax:widget.tax.toString()
                  // ));
                }
              },
            ),
          ],
        );
      },
    );
  }

  //show connected charger message
  Future<void> _showChargerMessage(int value) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Charging",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
              fontSize: 16.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Have you connected To charger?",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //No
                // FlatButton(
                //   child: Text(
                //     "No",
                //   ),
                //   onPressed: () {
                //    Get.back();
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      child: Text("No",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.fromLTRB(25, 10, 25, 10)),
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.green)))),
                      onPressed: () async {
                        setState(() {
                          proceed=true;
                        });
                      Get.offAndToNamed('/location');
                      }
        ),
                ),
                //yes
          //       FlatButton(
          //         child: Text(
          //           "Yes",
          //         ),
          //         onPressed: () {
          //           setState(() {
          //             loading=true;
          //             chargerConnected(value);
          //           });
          //
          // Get.back();
          //         },
          //       ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                      child: Text("Yes",
                          style: TextStyle(fontSize: 14, color: Colors.white)),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              EdgeInsets.fromLTRB(25, 10, 25, 10)),
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                          foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(color: Colors.green)))),
                      onPressed: () async {
                   setState(() {
                      loading=true;
                      proceed=true;
                      chargerConnected(value);
                    });

                  Get.back();
                      }
                  ),
                ),
              ],
            )

          ],
        );
      },
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay!.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Colors.white
          // Color.fromRGBO(19, 20, 21, 1)
          : Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Icon(Icons.arrow_back, color: Colors.black)),
        backgroundColor: Get.isDarkMode ? Colors.white : Colors.white,
        title: const Text(
          'Select Payments Methods',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 0.02.sh),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Pay through",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 0.02.sh),
          Card(
            child: Container(
              constraints: BoxConstraints(minHeight: 0.3.sh),
              margin: EdgeInsets.only(top: 15),
              decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Color.fromRGBO(37, 48, 63, 1)
                      : Colors.white),
              padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CheckoutHead(text: "Payment method".tr),
                    // InkWell(
                    //   child: CardItem(
                    //     title: "Stripe",
                    //     isActive: cartController.paymentType.value == 3,
                    //   ),
                    //   onTap: () {
                    //     setState(() {
                    //       cartController.paymentType.value = 3;
                    //     });
                    //     // cartController.paymentType.value = 3;
                    //     showModalBottomSheet(
                    //       context: context,
                    //       isScrollControlled: true,
                    //       backgroundColor: Colors.transparent,
                    //       builder: (_) {
                    //         return DraggableScrollableSheet(
                    //           expand: false,
                    //           builder: (_, controller) {
                    //             return AddCard(
                    //               scrollController: controller,
                    //             );
                    //           },
                    //         );
                    //       },
                    //     );
                    //   },
                    // ),
                    InkWell(
                      child: CardItem(
                        title: "Cash",
                        icon: const IconData(0xedf0, fontFamily: 'MIcon'),
                        isActive: cartController.paymentType.value == 1,
                      ),
                      onTap: () {
                        setState(() {
                          cartController.paymentType.value = 1;
                        });
                      },
                    ),
                    InkWell(
                      child: CardItem(
                        title: "RazorPay",
                        icon: const IconData(0xedf0, fontFamily: 'MIcon'),
                        isActive: cartController.paymentType.value == 2,
                      ),
                      onTap: () {
                        setState(() {
                          cartController.paymentType.value = 2;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),


                  ],
                ),
              ),
            ),
            // color: Colors.white,
            // child: Column(
            //   children: [
            //     InkWell(
            //       child: CardItem(
            //         title: "Stripe",
            //         isActive: cartController.paymentType.value == 3,
            //       ),
            //       onTap: () {
            //         cartController.paymentType.value = 3;
            //         showModalBottomSheet(
            //           context: context,
            //           isScrollControlled: true,
            //           backgroundColor: Colors.transparent,
            //           builder: (_) {
            //             return DraggableScrollableSheet(
            //               expand: false,
            //               builder: (_, controller) {
            //                 return AddCard(
            //                   scrollController: controller,
            //                 );
            //               },
            //             );
            //           },
            //         );
            //       },
            //     ),
            //     InkWell(
            //       child: CardItem(
            //         title: "Cash",
            //         icon: const IconData(0xedf0, fontFamily: 'MIcon'),
            //         isActive: cartController.paymentType.value == 1,
            //       ),
            //       onTap: () {
            //         cartController.paymentType.value = 1;
            //       },
            //     ),
            // Row(
            //   children: [
            //     Radio(
            //       value: 1,
            //       groupValue: val,
            //       onChanged: (value) {
            //         setState(() {
            //           val = val;
            //         });
            //       },
            //       activeColor: Colors.green,
            //     ),
            //     const Text("Razorpay",
            //         style: TextStyle(
            //             fontFamily: 'Inter',
            //             fontWeight: FontWeight.w400,
            //             fontSize: 16,
            //             color: Colors.black)),
            //   ],
            // ),
            //   const Divider(color: Colors.grey),
            //   Row(
            //     children: [
            //       Radio(
            //         value: 1,
            //         groupValue: val,
            //         onChanged: (value) {
            //           setState(() {
            //             val = val;
            //           });
            //         },
            //         activeColor: Colors.green,
            //       ),
            //       const Text("Paytm",
            //           style: TextStyle(
            //               fontFamily: 'Inter',
            //               fontWeight: FontWeight.w400,
            //               fontSize: 16,
            //               color: Colors.black)),
            //     ],
            //   )
            //   ],
            // ),
          ),
          SizedBox(height: 10.0),
         if(loading==true)
          Center(child:
              Column(
                children: [
                  SizedBox(
                    height: 25.0,
                    width: 25.0,
                    child:CircularProgressIndicator(strokeWidth: 1.5,),),
                  SizedBox(height: 10.0,),
                  Text("Please wait...",style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Sofia Pro'
                  ),)
                ],
              )
         ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 140,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.security, color: Colors.amber.shade600),
                Text("100 % Safe & Secure Payment",
                    style: TextStyle(color: Colors.grey.shade500)),
              ],
            ),
            SizedBox(height: 10),
            TextButton(

                child: Text("Proceed to pay",
                    style: TextStyle(fontSize: 16, color: proceed==false?Colors.white:Colors.black54)),
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.fromLTRB(90, 15, 90, 15)),
                    backgroundColor: proceed==false?MaterialStateProperty.all(Colors.green):MaterialStateProperty.all(Colors.grey),
                    foregroundColor:
                    proceed==false?MaterialStateProperty.all<Color>(Colors.green):MaterialStateProperty.all<Color>(Colors.grey),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side:proceed==false? BorderSide(color: Colors.green):BorderSide(color: Colors.grey)))),
                onPressed: proceed==false ?
                    () async {
                  if (cartController.paymentType.value == 2) {
                    openCheckout();
                  } else {
                    Fluttertoast.showToast(
                        msg: "Booked successfully",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    Future.delayed(Duration(milliseconds: 200), () {
                      //Get.offAndToNamed("/location");
                      cartController
                          .orderSave(
                              widget.startTime,
                              widget.endTime,
                              widget.date,
                              widget.productId.toString(),
                        double.parse(widget.totalAmt!.toStringAsFixed(2)),
                            widget.duration.toString(),
                        widget.tax.toString(),
                      )
                          .whenComplete(() {
                        if (widget.flag == "prebook") {
                          Get.offAndToNamed("/location");
                        } else {
                          _showChargerMessage(cartController.orderId.value);
                          // Get.to(TimerScreen(
                          //   amount: widget.amount.toString(),
                          //   duration: widget.duration.toString(),
                          //   paymentType:
                          //       cartController.paymentType.value.toString(),
                          //   date: widget.date,
                          //   // name: cartController.type.toString(),
                          //   name: widget.name,
                          //   chargingType:widget.chargingType,
                          //   imageUrl:widget.imageUrl,
                          //   port: cartController.port.toString(),
                          //     totalAmt:widget.totalAmt.toString(),
                          //     tax:widget.tax.toString()
                          //
                          //
                          // ));
                        }
                      });
                    });
                    // await cartController
                    //     .orderSave(
                    //         widget.startTime,
                    //         widget.endTime,
                    //         widget.date,
                    //         widget.productId.toString(),
                    //         widget.amount.toString())
                    //     .whenComplete(() => Get.toNamed("/location")
                    // Get.toNamed("/PaymentDone",arguments: user!.phoneNumber.toString())
                    //);
                  }

                  // Get.toNamed("/PaymentDone");
                }
                :null,),
          ],
        ),
      ),
    );
  }
}
