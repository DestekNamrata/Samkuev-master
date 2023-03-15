import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:samku/src/pages/order_history.dart';
import 'package:samku/src/pages/profile.dart';

import '../../config/global_config.dart';
import 'package:http/http.dart' as http;


class MyPreBookDetail extends StatefulWidget{
  String? imageUrl,stationName,chargerPortName,startTime,endTime,startDate,endDate,duration,amount,power;
  int? id;

  MyPreBookDetail({Key? key,@required this.id,@required this.imageUrl,@required this.stationName,@required this.chargerPortName,
  @required this.amount,@required this.power,@required this.startTime,@required this.endTime,@required this.startDate,@required this.endDate,
  @required this.duration}):super(key: key);
  _MyPreBookDetailState createState()=>_MyPreBookDetailState();
}

class _MyPreBookDetailState extends State<MyPreBookDetail>{
  DateTime currentTime=new DateTime.now();
  DateTime? startTime,endTime;
  bool enabledFlag=false;
  bool loading=false;
  var date;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime=DateTime.parse(widget.endDate.toString()+" "+widget.startTime.toString()) ;
    endTime=DateTime.parse(widget.endDate.toString()+" "+widget.endTime.toString()) ;

    date = currentTime.year.toString() + "-" + currentTime.month.toString() + "-" + currentTime.day.toString();
    calculateTimerCondition(startTime,endTime,date);
  }

  void calculateTimerCondition(DateTime? startTime,DateTime? endTime, date){
    print(widget.endDate);
    if(currentTime.toString().contains(widget.endDate!)){
      if((currentTime.compareTo(startTime!)>0) //currenTime is after startTime
          && (currentTime.compareTo(endTime!)<0)){ //currenTime is before endTime
         setState(() {
           enabledFlag=true;
         });
      }
    }
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
                        Get.back();
                        Get.back();
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
              loading = false;
            });
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OrderHistory(tabIndex: 1,)));

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
    'Preebook Detail',
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
         //amount
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Amount :",
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
                Text(widget.startDate!,
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: Colors.black))
              ],
            ),
          ),

          //click to start
         if(enabledFlag==true)
          Padding(
            padding: const EdgeInsets.only(top:35.0,left:15.0,right: 15.0),
            child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.fromLTRB(90, 15, 90, 15)),
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                            side: BorderSide(color: Colors.green)))),
                onPressed:!loading ? () async {
                  _showChargerMessage(widget.id!);
                     } :
                   null,
              child:
              // Text("Click to start",
              //     style: TextStyle(fontSize: 16, color: Colors.white)),
              loading==false
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child:   Text("Click to start",
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              )
                  : Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),

                ),
          ),


        ],
      ),
    )
    );
  }

}