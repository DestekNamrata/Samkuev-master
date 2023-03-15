import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/order_controller.dart';

class ChargingHistoryDetail extends StatefulWidget{
  String? imageUrl,stationName,chargerPortName,startTime,endTime,startDate,endDate,duration,amount,power,taxamt,taxPerc;
  int? id;

  ChargingHistoryDetail({Key? key,@required this.id,@required this.imageUrl,@required this.stationName,@required this.chargerPortName,
    @required this.amount,@required this.power,@required this.startTime,@required this.endTime,@required this.startDate,@required this.endDate,
    @required this.duration,@required this.taxamt,@required this.taxPerc}):super(key: key);

  _ChargingHistoryDetailState createState()=>_ChargingHistoryDetailState();
}

class _ChargingHistoryDetailState extends State<ChargingHistoryDetail>{

  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
            'Charging History Detail',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body:Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 25.0,),
              Center(child:
              Column(
                children: [
                  //image
                  Image.network(
                    widget.imageUrl!,
                    height: 120.0,
                    width: 120.0,
                    fit: BoxFit.fitHeight,
                  ),
                  SizedBox(height: 10.0,),
                  Text(widget.stationName!,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black)),
                  //charger port name
                  SizedBox(height: 5.0,),
                  Text(widget.chargerPortName!,
                      style: TextStyle(
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Colors.black))
                ],
              )),
              SizedBox(height: 10.0,),
              Divider(height: 1,color: Colors.grey,),
              SizedBox(height: 15.0,),
              //startTDate
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Date :",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black)),
                    Text(orderController
                        .getTime(widget.startDate!+" "+widget.startTime!),
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.black))
                  ],
                ),
              ),
              //startTime
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Start Time :",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black)),
                    Text(widget.startTime!,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.black))
                  ],
                ),
              ),
              //end Time
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("End Time :",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black)),
                    Text(widget.endTime!,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.black))
                  ],
                ),
              ),
              //duration
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Duration :",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black)),
                    Text(widget.duration!+" Min",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.black))
                  ],
                ),
              ),
              //power
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Power :",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black)),
                    Text(widget.power!,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.black))
                  ],
                ),
              ),
              //tax
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tax : "+widget.taxPerc.toString(),
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black)),
                    Text(widget.taxamt!.toString(),
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.black))
                  ],
                ),
              ),
              //amount
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total Amount :",
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black)),
                    Text(widget.amount!,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: Colors.black))
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
  
}