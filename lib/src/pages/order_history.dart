import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:samku/src/pages/chargeingHistory_detail.dart';
import '../../config/global_config.dart';
import '/src/components/appbar.dart';
import '/src/components/empty.dart';
import '/src/components/order_history_dialog.dart';
import '/src/components/order_history_info.dart';
import '/src/components/order_history_item.dart';
import '/src/components/order_history_tab.dart';
import '/src/components/shadows/order_history_item_shadow.dart';
import '/src/controllers/auth_controller.dart';
import '/src/controllers/chat_controller.dart';
import '/src/controllers/language_controller.dart';
import '/src/controllers/order_controller.dart';
import '/src/models/chat_user.dart';
import 'package:intl/intl.dart';


class OrderHistory extends StatefulWidget {
  int? tabIndex;
  OrderHistory({Key? key,@required this.tabIndex}):super(key: key);
  @override
  OrderHistoryState createState() => OrderHistoryState();
}

class OrderHistoryState extends State<OrderHistory>
    with TickerProviderStateMixin {
  TabController? tabController;
  final AuthController authController = Get.put(AuthController());
  final OrderController orderController = Get.put(OrderController());
  final LanguageController languageController = Get.put(LanguageController());
  int tabIndex = 0;
  final CountDownController _controller = CountDownController();

  @override
  void initState() {
    super.initState();
   if(widget.tabIndex!=null){
     tabIndex=widget.tabIndex!; //coming from prebooking to running
   }else{
     tabIndex=0;
   }
    tabController = new TabController(length: 3, vsync: this);

  }

  void showSheet(item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return SingleChildScrollView(
              child: OrderHistoryDialog(
                data: item,
              ),
              controller: controller,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var statusBarHeight = MediaQuery.of(context).padding.top;
    var appBarHeight = AppBar().preferredSize.height;

    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Color.fromRGBO(19, 20, 21, 1)
          : Color.fromRGBO(243, 243, 240, 1),
      appBar: AppBar(
        
        title: Text(
          "My orders".tr,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        // backwardsCompatibility: true,
        // hasBack: true,
        actions: [OrderHistoryInfo()],
        // actions: OrderHistoryInfo(),
      ),
      body: SizedBox(
        height: 1.sh - appBarHeight,
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                width: 1.sw,
                height: 60,
                decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? Color.fromRGBO(26, 34, 44, 1)
                        : Color.fromRGBO(249, 249, 246, 1)),
                child: TabBar(
                    controller: tabController,
                    indicatorColor: Color.fromRGBO(69, 165, 36, 1),
                    indicatorWeight: 2,
                    labelColor: Get.isDarkMode
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 0, 0, 1),
                    unselectedLabelColor: Get.isDarkMode
                        ? Color.fromRGBO(130, 139, 150, 1)
                        : Color.fromRGBO(136, 136, 126, 1),
                    labelStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      letterSpacing: -0.4,
                    ),
                    onTap: (index) {
                      setState(() {
                        tabIndex = index;
                      });

                      orderController.load.value = true;
                      orderController.ordersList.value = [];
                    },
                    tabs: [
                      Tab(
                          child: OrderHistoryTab(
                        name: "Completed".tr,
                        type: 1,
                      )),
                      Tab(
                          child: OrderHistoryTab(
                              name: "Running".tr,
                              // type: 2,
                              type: 1,
                              // count: orderController.newOrderCount.value
                          )
                      ),
                      Tab(
                          child: OrderHistoryTab(
                        name: "Cancelled".tr,
                        type: 3,
                      )),
                    ]),
              ),
              Container(
                child: [
                  Container(
                    width: 1.sw,
                    height: 1.sh - 160,
                    child: tabIndex == 0
                        ? FutureBuilder<List>(
                            future: orderController.getOrderHistory(
                                authController.user.value!,
                                4,
                                languageController.activeLanguageId.value),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return snapshot.data!.isEmpty
                                    ? Empty(message: "No completed orders".tr)
                                    : ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 20),
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> data =
                                              snapshot.data![index];

                                          return InkWell(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                  ChargingHistoryDetail(
                                                      id:data['id'],
                                                      imageUrl:'$GLOBAL_IMAGE_URL'+data['shop']['backimage_url'],
                                                      chargerPortName:data['details'][0]['product']['language']['name'].toString(),
                                                      stationName:data['shop']['language']['name'].toString(),
                                                      amount:"\u20b9 "+data['amount'].toString(),
                                                      power:"${data['details'][0]['product']['power']} kw ",
                                                      startTime:data["start_time"].toString(),
                                                      endTime:data["end_time"].toString(),
                                                      duration:data["duration"].toString(),
                                                      startDate:data["delivery_date"].toString(),
                                                      endDate:data["end_date"].toString(),
                                                    taxamt: "\u20b9 "+data['tax'].toString(),
                                                    taxPerc: data['shop']['tax'].toString()+"%",

                                                  )));
                                            },
                                              child:
                                            OrderHistoryItem(
                                            shopName: data['shop']['language']
                                                ['name'],
                                            status: 4,
                                            orderId: data['id'],
                                            orderDate: orderController
                                                .getTime(data['delivery_date']+" "+data['start_time']),
                                            amount: double.parse(
                                                data['total_sum'].toString()),
                                          ));
                                        });
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              return ListView.builder(
                                  itemCount: 4,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  itemBuilder: (context, index) {
                                    return OrderHistoryItemShadow();
                                  });
                            })
                        : Container(),
                  ),
                  Container(
                    width: 1.sw,
                    height: 1.sh - 150,
                    child: tabIndex == 1
                        ? FutureBuilder<List>(
                            future: orderController.getOrderHistory(
                                authController.user.value!,
                                2, //running
                                languageController.activeLanguageId.value),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return snapshot.data!.isEmpty
                                    ? Empty(message: "No Running orders".tr)
                                    :
                                ListView.builder(
                                        // itemCount: snapshot.data!.length,
                                        itemCount: 1,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 20),
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> data =
                                              snapshot.data![0];
                                              // snapshot.data![index];
                                          // return OrderHistoryItem(
                                          //   shopName: data['shop']['language']
                                          //       ['name'],
                                          //   status: 1,
                                          //   onTapBtn: () {
                                          //     if (data['delivery_boy'] !=
                                          //         null) {
                                          //       ChatController chatController =
                                          //           Get.put(ChatController());
                                          //       chatController.user.value =
                                          //           ChatUser(
                                          //               imageUrl:
                                          //                   data['delivery_boy']
                                          //                       ['image_url'],
                                          //               name:
                                          //                   "${data['delivery_boy']['name']} ${data['delivery_boy']['surname']}",
                                          //               id: data['delivery_boy']
                                          //                   ['id'],
                                          //               role: 2);
                                          //     }
                                          //
                                          //     orderController
                                          //         .setActiveOrder(data);
                                          //
                                          //     showSheet(data);
                                          //   },
                                          //   orderId: data['id'],
                                          //   orderDate: orderController
                                          //       .getTime(data['created_at']),
                                          //   amount: double.parse(
                                          //       data['total_sum'].toString()),
                                          // );

                                          //updated on 17/05/2022
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: Card(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(20.0),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(data['shop']['language']['name'].toString(),
                                                              style: TextStyle(
                                                                  color: Colors.black,
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.w600)),
                                                          SizedBox(
                                                            height: 0.01.sh,
                                                          ),
                                                          ListTile(
                                                            leading: Image.network('$GLOBAL_IMAGE_URL'+data['shop']['backimage_url'],
                                                                width: 60, height: 70),
                                                            title: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              // ignore: prefer_const_literals_to_create_immutables
                                                              children: [
                                                                // Text("Ac 3.3 pin",
                                                                //     style: TextStyle(
                                                                //         color: Colors.black,
                                                                //         fontSize: 16,
                                                                //         fontWeight: FontWeight.w600)),
                                                                Text(data['details'][0]['product']['language']['name'].toString(),
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w600))
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    child: CircularCountDownTimer(
                                                      // Countdown duration in Seconds.

                                                      duration: data['timer_in_minutes']*60,

                                                      // Countdown initial elapsed Duration in Seconds.
                                                      initialDuration: 0,

                                                      // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
                                                      controller: _controller,

                                                      // Width of the Countdown Widget.
                                                      width: MediaQuery.of(context).size.width / 2,

                                                      // Height of the Countdown Widget.
                                                      height: MediaQuery.of(context).size.height / 3.5,

                                                      // Ring Color for Countdown Widget.
                                                      ringColor: Colors.grey[300]!,

                                                      // Ring Gradient for Countdown Widget.
                                                      ringGradient: null,

                                                      // Filling Color for Countdown Widget.
                                                      fillColor: Colors.orange[500]!,

                                                      // Filling Gradient for Countdown Widget.
                                                      fillGradient: null,

                                                      // Background Color for Countdown Widget.
                                                      backgroundColor: Colors.white,

                                                      // Background Gradient for Countdown Widget.
                                                      backgroundGradient: null,

                                                      // Border Thickness of the Countdown Ring.
                                                      strokeWidth: 20.0,

                                                      // Begin and end contours with a flat edge and no extension.
                                                      strokeCap: StrokeCap.round,

                                                      // Text Style for Countdown Text.
                                                      textStyle: const TextStyle(
                                                        fontSize: 33.0,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                      ),

                                                      // Format for the Countdown Text.
                                                      textFormat: CountdownTextFormat.HH_MM_SS,

                                                      // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
                                                      isReverse: true,

                                                      // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
                                                      isReverseAnimation: true,

                                                      // Handles visibility of the Countdown Text.
                                                      isTimerTextShown: true,

                                                      // Handles the timer start.
                                                      autoStart: true,

                                                      // This Callback will execute when the Countdown Starts.
                                                      onStart: () {
                                                        // Here, do whatever you want
                                                        debugPrint('Countdown Started');
                                                      },

                                                      // This Callback will execute when the Countdown Ends.
                                                      onComplete: () {
                                                        // Here, do whatever you want
                                                        debugPrint('Countdown Ended');
                                                        Fluttertoast.showToast(
                                                            msg: "Charging completed",
                                                            toastLength: Toast.LENGTH_LONG,
                                                            gravity: ToastGravity.BOTTOM,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: Colors.green,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0);
                                                        Future.delayed(Duration(milliseconds: 200), () {
                                                          Get.offAndToNamed("/location");
                                                        });
                                                      },
                                                    )),
                                                Card(
                                                    margin: const EdgeInsets.only(top: 20),
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                                                      child: Column(children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                                          // ignore: prefer_const_literals_to_create_immutables
                                                          children: [
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,

                                                              children: [
                                                                const Text("Order ID :",
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w400)),
                                                                SizedBox(height: 5.0,),
                                                                Text("OD-"+data['id'].toString(),
                                                                    style: const TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w600))
                                                              ],
                                                            ),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                const Text("Date:",
                                                                    style: TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w400)),
                                                                SizedBox(height: 5.0,),
                                                                // Text(orderController.getTime(data['created_at']),
                                                                Text(DateFormat('d MMM yyyy').format(DateTime.parse(data['created_at'])),
                                                                    style: const TextStyle(
                                                                        color: Colors.black,
                                                                        fontSize: 16,
                                                                        fontWeight: FontWeight.w600))
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 0.01.sh,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            const Text("Charge Type :",
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w400)),
                                                            Text(
                                                                data['payment_status'] == 1
                                                                    ? "Cash"
                                                                    : "RazorPay",
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 0.01.sh,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          // ignore: prefer_const_literals_to_create_immutables
                                                          children: [
                                                            const Text("Charge Fare :",
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w400)),
                                                            Text(
                                                              // _radioValue1 == 1
                                                              // ? "\u20b9 ${amount!}.00"
                                                              //     : "\u20b9 ${time!}",
                                                              // cartController.calculateAmount(),
                                                            "\u20b9 "+data['total_sum'].toString(),
                                                                style: const TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500))
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 0.01.sh,
                                                        ),
                                                        // Row(
                                                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        //   // ignore: prefer_const_literals_to_create_immutables
                                                        //   children: [
                                                        //     const Text("Offer apply  :",
                                                        //         style: TextStyle(
                                                        //             color: Colors.green,
                                                        //             fontSize: 16,
                                                        //             fontWeight: FontWeight.w400)),
                                                        //     Text(
                                                        //       /* "\u20b9 -$discountprice.00"*/
                                                        //         "${.proccessPercentage.value}",
                                                        //         style: const TextStyle(
                                                        //             color: Colors.red,
                                                        //             fontSize: 16,
                                                        //             fontWeight: FontWeight.w500))
                                                        //   ],
                                                        // ),
                                                        SizedBox(
                                                          height: 0.01.sh,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          // ignore: prefer_const_literals_to_create_immutables
                                                          children: [
                                                            Text("Tax : "+data['shop']["tax"].toString()+"%",
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w400)),
                                                            Text("\u20b9 "+data['tax'].toString(),
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500))
                                                          ],
                                                        ),
                                                        Divider(
                                                          color: Colors.grey.shade300,
                                                          thickness: 0.8,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          // ignore: prefer_const_literals_to_create_immutables
                                                          children: [
                                                            const Text("Total :",
                                                                style: TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500)),
                                                            Text(
                                                              //                           _radioValue1 == 1
                                                              // ? "\u20b9 ${total = discountprice! + amount!}.00"
                                                              //     : "\u20b9 ${total = discountprice! + time!}.00"
                                                                "\u20b9 "+data['total_sum'].toString(),
                                                                style: const TextStyle(
                                                                    color: Colors.black,
                                                                    fontSize: 16,
                                                                    fontWeight: FontWeight.w500))
                                                          ],
                                                        ),
                                                      ]),
                                                    )),
                                              ],
                                            );
                                        });
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              return ListView.builder(
                                  itemCount: 4,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  itemBuilder: (context, index) {
                                    return OrderHistoryItemShadow();
                                  });
                            })
                        : Container(),
                  ),
                  Container(
                    width: 1.sw,
                    height: 1.sh - 165,
                    child: tabIndex == 2
                        ? FutureBuilder<List>(
                            future: orderController.getOrderHistory(
                                authController.user.value!,
                                5,
                                languageController.activeLanguageId.value),
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                return snapshot.data!.isEmpty
                                    ? Empty(message: "No canceled orders".tr)
                                    : ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 20),
                                        itemBuilder: (context, index) {
                                          Map<String, dynamic> data =
                                              snapshot.data![index];

                                          return InkWell(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                  ChargingHistoryDetail(
                                                      id:data['id'],
                                                      imageUrl:'$GLOBAL_IMAGE_URL'+data['shop']['backimage_url'],
                                                      chargerPortName:data['details'][0]['product']['language']['name'].toString(),
                                                      stationName:data['shop']['language']['name'].toString(),
                                                      amount:"\u20b9 "+data['amount'].toString(),
                                                      power:"${data['details'][0]['product']['power']} kw ",
                                                      startTime:data["start_time"].toString(),
                                                      endTime:data["end_time"].toString(),
                                                      duration:data["duration"].toString(),
                                                      startDate:data["delivery_date"].toString(),
                                                      endDate:data["end_date"].toString()

                                                  )));
                                            },
                                              child:
                                            OrderHistoryItem(
                                            shopName: data['shop']['language']
                                                ['name'],
                                            orderId: data['id'],
                                            status: 5,
                                            orderDate: orderController
                                                .getTime(data['delivery_date']+" "+data['start_time']),
                                            amount: double.parse(
                                                data['total_sum'].toString()),
                                          ));
                                        });
                              } else if (snapshot.hasError) {
                                return Text("${snapshot.error}");
                              }

                              return ListView.builder(
                                  itemCount: 4,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 20),
                                  itemBuilder: (context, index) {
                                    return OrderHistoryItemShadow();
                                  });
                            })
                        : Container(),
                  ),
                ][tabIndex],
              )
            ],
          ),
        ),
      ),
    );
  }
}
