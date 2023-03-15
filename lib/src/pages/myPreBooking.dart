import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:samku/src/pages/myprebookDetailPage.dart';
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

class MyPreBooking extends StatefulWidget {
  @override
  MyPreBookingState createState() => MyPreBookingState();
}

class MyPreBookingState extends State<MyPreBooking>
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

    tabController = new TabController(length: 2, vsync: this);

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
      appBar:PreferredSize(
    preferredSize: Size(1.sw, statusBarHeight + appBarHeight),
    child: AppBarCustom(
        title: "My Pre Booking".tr,
        hasBack: true,
      )),
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
                      if(mounted) {
                        setState(() {
                          tabIndex = index;
                        });
                      }

                      orderController.load.value = true;
                      orderController.preBookList.value = [];
                    },
                    tabs: [
                      Tab(
                          child: OrderHistoryTab(
                            name: "Today".tr,
                            type: 1,
                          )),
                      Tab(
                          child: OrderHistoryTab(
                              name: "Tomorrow".tr,
                              type: 1,
                              // count: orderController.newOrderCount.value
                          )),

                    ]),
              ),
              Container(
                child: [
                  //today
                  Container(
                    width: 1.sw,
                    height: 1.sh - 165,
                    child: tabIndex == 0
                        ? FutureBuilder<List>(
                        future: orderController.getPreBook(
                            authController.user.value!,
                            1,
                            languageController.activeLanguageId.value,
                        1 //for today
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            return snapshot.data!.isEmpty
                                ? Empty(message: "No completed PreBook".tr)
                                : ListView.builder(
                                itemCount: snapshot.data!.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                  snapshot.data![index];

                                  // return OrderHistoryItem(
                                  //   shopName: data['shop']['language']
                                  //   ['name'],
                                  //   status: 4,
                                  //   orderId: data['id'],
                                  //   orderDate: orderController
                                  //       .getTime(data['created_at']),
                                  //   amount: double.parse(
                                  //       data['total_sum'].toString()),
                                  // );

                                  return InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                      MyPreBookDetail(
                                        id: data['id'],
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
                                    Card(
                                    // color: isSelected?Colors.green:Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 1,
                                    shadowColor: Colors.grey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ListTile(
                                        selectedColor: Colors.green,
                                        selectedTileColor: Colors.green,
                                        selected: false,
                                        dense: true,
                                        isThreeLine: true,
                                        leading: Image.network(
                                          '$GLOBAL_IMAGE_URL'+data['shop']['backimage_url'],
                                          width: 0.2.sw,
                                          fit: BoxFit.fitHeight,
                                        ),
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(child:Text(data['shop']['language']['name'],
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 14.sp,
                                                        color: Colors.black))),
                                                // Container(
                                                //   height: 25,
                                                //   width: 0.25.sw,
                                                //   decoration: BoxDecoration(
                                                //       borderRadius: BorderRadius.circular(5),
                                                //       color: product?.status == 1 //available
                                                //           ? Colors.green
                                                //           : product?.status == 2 //currently using
                                                //           ? Colors.yellow
                                                //           : product?.status == 3 //notworking
                                                //           ? Colors.red
                                                //           : Colors.black), //faulty
                                                //   child: Center(
                                                //     child: Text("${product?.statusName}",
                                                //         style: TextStyle(
                                                //             fontFamily: 'Inter',
                                                //             fontWeight: FontWeight.bold,
                                                //             fontSize: 12.sp,
                                                //             color: Colors.white)),
                                                //   ),
                                                // ),
                                                // Flexible(child:Text(data["start_time"].toString(),
                                                //     style: TextStyle(
                                                //         fontFamily: 'Inter',
                                                //         fontWeight: FontWeight.w400,
                                                //         fontSize: 14.sp,
                                                //         color: Colors.black))),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(data['details'][0]['product']['language']['name'],
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18.sp,
                                                    color: Colors.black)),
                                            SizedBox(height: 10.h),
                                          ],
                                        ),
                                        subtitle: Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time_filled_sharp,
                                              color: Colors.black,
                                            ),
                                            SizedBox(width: 10.w),
                                            Text("\u20b9 "+data['amount'].toString(),
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 18.sp,
                                                    color: Colors.black)),
                                            SizedBox(width: 15.w),
                                            Icon(
                                              const IconData(0xf239, fontFamily: 'MaterialIcons'),
                                              size: 20.sp,
                                              color: Get.isDarkMode
                                                  ? const Color.fromRGBO(130, 139, 150, 1)
                                                  : const Color.fromRGBO(100, 200, 100, 1),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              "${data['details'][0]['product']['power']} kw ",
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 18.sp,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                  //tomorrow
                  Container(
                    width: 1.sw,
                    height: 1.sh - 165,
                    child: tabIndex == 1
                        ? FutureBuilder<List>(
                        future: orderController.getPreBook(
                            authController.user.value!,
                            1,
                            languageController.activeLanguageId.value,
                            2 //for tomorrow
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.connectionState ==
                                  ConnectionState.done) {
                            return snapshot.data!.isEmpty
                                ? Empty(message: "No completed PreBook".tr)
                                : ListView.builder(
                                itemCount: snapshot.data!.length,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 20),
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data = snapshot.data![index];
                                  // var amt=int.parse(data['amount']).toStringAsFixed(2);
                                  return InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                            MyPreBookDetail(
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
                                    Card(
                                    // color: isSelected?Colors.green:Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 1,
                                    shadowColor: Colors.grey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: ListTile(
                                        selectedColor: Colors.green,
                                        selectedTileColor: Colors.green,
                                        selected: false,
                                        dense: true,
                                        isThreeLine: true,
                                        leading: Image.network(
                                          '$GLOBAL_IMAGE_URL'+data['shop']['backimage_url'],
                                          width: 0.2.sw,
                                          fit: BoxFit.fitHeight,
                                        ),
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Flexible(child:Text(data['shop']['language']['name'],
                                                    style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 14.sp,
                                                        color: Colors.black))),
                                                // Container(
                                                //   height: 25,
                                                //   width: 0.25.sw,
                                                //   decoration: BoxDecoration(
                                                //       borderRadius: BorderRadius.circular(5),
                                                //       color: product?.status == 1 //available
                                                //           ? Colors.green
                                                //           : product?.status == 2 //currently using
                                                //           ? Colors.yellow
                                                //           : product?.status == 3 //notworking
                                                //           ? Colors.red
                                                //           : Colors.black), //faulty
                                                //   child: Center(
                                                //     child: Text("${product?.statusName}",
                                                //         style: TextStyle(
                                                //             fontFamily: 'Inter',
                                                //             fontWeight: FontWeight.bold,
                                                //             fontSize: 12.sp,
                                                //             color: Colors.white)),
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(data['details'][0]['product']['language']['name'],
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 18.sp,
                                                    color: Colors.black)),
                                            SizedBox(height: 10.h),
                                          ],
                                        ),
                                        subtitle: Row(
                                          children: [
                                            const Icon(
                                              Icons.access_time_filled_sharp,
                                              color: Colors.black,
                                            ),
                                            SizedBox(width: 10.w),
                                            Text("\u20b9 "+data['amount'].toString(),
                                                style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 18.sp,
                                                    color: Colors.black)),
                                            SizedBox(width: 15.w),
                                            Icon(
                                              const IconData(0xf239, fontFamily: 'MaterialIcons'),
                                              size: 20.sp,
                                              color: Get.isDarkMode
                                                  ? const Color.fromRGBO(130, 139, 150, 1)
                                                  : const Color.fromRGBO(100, 200, 100, 1),
                                            ),
                                            SizedBox(width: 10.w),
                                            Text(
                                              "${data['details'][0]['product']['power']} kw ",
                                              style: TextStyle(
                                                  fontFamily: 'Inter',
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 18.sp,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
