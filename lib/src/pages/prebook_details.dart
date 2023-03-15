import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samku/src/controllers/category_controller.dart';

import '/src/components/home_silver_bar.dart';
import '/src/controllers/auth_controller.dart';
import '/src/controllers/notification_controller.dart';
import 'chargedetails.dart';

class PreBookDetails extends StatefulWidget {
  int? qrdata;

  PreBookDetails({Key? key, this.qrdata}) : super(key: key);
  @override
  PreBookDetailsState createState() => PreBookDetailsState();
}

class PreBookDetailsState extends State<PreBookDetails>
    with TickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());
  final CategoryController categoryController = Get.put(CategoryController());
  final NotificationController notificationController =
      Get.put(NotificationController());
  // int tabIndex = 2;
  bool onClick = true;
  var tabIndex = 0.obs;
  var categories = ["Today", "Tomorrow"];
  late double _height;
  late double _width;

  late String _setTime, _setDate;

  late String _hour, _minute, _time;

  late String dateTime;

  String day = "today";
  String today="",tomorrow="";

   DateTime? t;
  DateTime selectedDate = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  TimeOfDayFormat timeFormatter = TimeOfDayFormat.h_colon_mm_space_a;

  //TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedTime = TimeOfDay.now();

  String formattedTime = "",time="";

  // TextEditingController _dateController = TextEditingController();
  // TextEditingController _timeController = TextEditingController();

  var timeSelected = false;
  bool isTodaySelected=false;
  bool istomorrowSelected=false;

  @override
  void initState() {
    // _timeController.text =
    //     DateTime(2019, 08, 1, DateTime.now().hour, DateTime.now().minute)
    //         as String;
    super.initState();
    day = formatter.format(selectedDate);
    if(isTodaySelected==true) {
      today = day;
    }
    // _selectTime(context);
    //notificationController.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    //dateTime = DateFormat.yMd().format(DateTime.now());
    return Scaffold(
      backgroundColor: Get.isDarkMode
          ? Colors.white
          // Color.fromRGBO(19, 20, 21, 1)
          : Colors.grey.shade50,
      // Color.fromRGBO(243, 243, 240, 1),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[HomeSilverBar()];
        },
        body: Container(
            padding: const EdgeInsets.only(bottom: 10, top: 30),
            child: Column(

              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 0.45.sw,
                                height: 0.06.sh,
                                decoration: BoxDecoration(
                                    color: isTodaySelected==false?Colors.grey.shade100:Colors.green,
                                    borderRadius: BorderRadius.circular(60)),
                                child: TextButton(
                                    child:
                                    Text("Today",
                                        style: TextStyle(fontSize: 14,color: isTodaySelected==false?Colors.green:Colors.white)),
                                    style: ButtonStyle(
                                      // padding: MaterialStateProperty.all<EdgeInsets>(
                                      //     EdgeInsets.fromLTRB(40, 15, 40, 15)),

                                        foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(40),
                                                side:
                                                BorderSide(color: Colors.green)))),
                                    onPressed: () {
                                      setState(() {
                                        isTodaySelected=true;
                                        if(istomorrowSelected==true){
                                          istomorrowSelected=false;
                                        }
                                      });
                                      formattedTime = DateFormat.jm().format(DateTime.now());
                                      day = formatter.format(DateTime(
                                          selectedDate.year,
                                          selectedDate.month,
                                          selectedDate.day));
                                      today=day;
                                      _selectTime(context,"0"); //for today
                                    }),
                              )),
                          SizedBox(height:10.0),
                          if( isTodaySelected==true)
                          Text(today.toString(),
                              style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold)),
                        ],
                      ),
                     Column(
                       children: [
                         ClipRRect(
                             borderRadius: BorderRadius.circular(10),
                             child: Container(
                               width: 0.45.sw,
                               height: 0.06.sh,
                               decoration: BoxDecoration(
                                   color:istomorrowSelected==false?Colors.grey.shade100:Colors.green,
                                   borderRadius: BorderRadius.circular(60)),
                               child:
                               TextButton(
                                   child: Text("Tomorrow",
                                       style: TextStyle(fontSize: 14,color: istomorrowSelected==false?Colors.green:Colors.white)),
                                   style: ButtonStyle(
                                     // padding: MaterialStateProperty.all<EdgeInsets>(
                                     //     EdgeInsets.fromLTRB(40, 15, 40, 15)),
                                       foregroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                       shape: MaterialStateProperty.all<
                                           RoundedRectangleBorder>(
                                           RoundedRectangleBorder(
                                               borderRadius:
                                               BorderRadius.circular(40),
                                               side:
                                               BorderSide(color: Colors.green)))),
                                   onPressed: () {
                                     setState(() {
                                       istomorrowSelected=true;
                                       if(isTodaySelected==true){
                                         isTodaySelected=false;
                                       }
                                     });
                                     formattedTime = DateFormat.jm().format(DateTime.now());
                                     day = formatter.format(DateTime(
                                         selectedDate.year,
                                         selectedDate.month,
                                         selectedDate.day + 1));
                                     tomorrow=day;
                                     _selectTime(context,"1");
                                   }),
                             )
                         ),
                         SizedBox(height:10.0),
                         if(istomorrowSelected==true)
                         Text(tomorrow.toString(),
                             style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold)),
                       ],
                     )

                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),

                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    formattedTime == "" ? 'Select the time by selecting today or tomorrow' :
                    'Your selected time is $formattedTime',
                    style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        letterSpacing: -0.2,
                        color: Colors.black),
                  ),
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      /*  DigitalClock(
                        digitAnimationStyle: Curves.elasticOut,
                        is24HourTimeFormat: false,
                        showSecondsDigit: false,
                        areaDecoration: BoxDecoration(
                          color: Colors.transparent,
                        ),
                        hourMinuteDigitTextStyle: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 50,
                        ),
                        amPmDigitTextStyle: TextStyle(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      ),*/
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
                TextButton(
                    child: Text("Confirm", style: TextStyle(fontSize: 14)),
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.fromLTRB(40, 15, 40, 15)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.green),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    side: BorderSide(color: Colors.green)))),
                    onPressed: () {
                      // if (categoryController.qrData != null) {
                      if(t==null)
                        {
                          Fluttertoast.showToast(
                              msg: "Please select the time by selecting today or tomorrow",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        }else {
                        Get.to(
                          ChargeingDetails(
                              qrdata: categoryController.qrData!,
                              date: day,
                              time: t,
                              startTime: time,
                              flag: "prebook"),
                        );
                      }
                      // } else {
                      //   Fluttertoast.showToast(msg: "Please select time");
                      // }
                    }),
                //   ],
                // ),
                //),
              ],
            )),
      ),
      /*bottomNavigationBar:*/
    );
  }

  _selectTime(BuildContext context,String flagDay) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        // initialTime: selectedTime,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial,
    builder: (context,child){ //used for 24 hours format
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child ?? Container(),
      );
    });


    print('selected time $selectedTime');
    var now=TimeOfDay.now();
    // var selectTime=timeOfDay;
    // DayPeriod dayPeriod = timeOfDay!.period;
     var hourNow=now.hour;
     var hourSelected=timeOfDay!.hour;
     if(flagDay=="0"){ //for today
       if(hourSelected>=hourNow){
         // if (timeOfDay != null && timeOfDay != selectedTime) {
         if (timeOfDay != null ) {
           final localizations = MaterialLocalizations.of(context);
           final formattedTimeOfDay = localizations.formatTimeOfDay(timeOfDay);
           setState(() {
             // t = new DateTime(timeOfDay.hour, timeOfDay.minute, 00);
             formattedTime = formattedTimeOfDay.toString();
             // formattedTime = timeOfDay.toString();
             String hour="",minutes;
             //for hours
             if(timeOfDay.hour.toString().length==1){
               hour="0"+timeOfDay.hour.toString();
             }else{
               hour=timeOfDay.hour.toString();
             }

             //for minutes
             if(timeOfDay.minute.toString().length==1){
               minutes="0"+timeOfDay.minute.toString();
             }else{
               minutes=timeOfDay.minute.toString();
             }
             time = hour+":"+minutes+":00";
             t=DateTime.parse(day+" "+time);
             print('selected time $t');
           });

       }
         else {
           Fluttertoast.showToast(
               msg: "Please select proper time",
               toastLength: Toast.LENGTH_SHORT,
               gravity: ToastGravity.BOTTOM,
               timeInSecForIosWeb: 1,
               backgroundColor: Colors.green,
               textColor: Colors.white,
               fontSize: 16.0);
         }
       }else{
         Fluttertoast.showToast(
             msg: "Please select time greater than current Time",
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.green,
             textColor: Colors.white,
             fontSize: 16.0);
       }

     }else{

         // if (timeOfDay != null && timeOfDay != selectedTime) {
         if (timeOfDay != null ) {
           final localizations = MaterialLocalizations.of(context);
           final formattedTimeOfDay = localizations.formatTimeOfDay(timeOfDay);
           print("formattedTimeOfDay:-"+formattedTimeOfDay);
           setState(() {
             // t = new DateTime(timeOfDay.hour, timeOfDay.minute, 00);
             formattedTime = formattedTimeOfDay.toString();
             print("formattedTime:-"+formattedTime);
             // formattedTime = timeOfDay.toString();
             String hour="",minutes;
             //for hours
             if(timeOfDay.hour.toString().length==1){
               hour="0"+timeOfDay.hour.toString();
             }else{
               hour=timeOfDay.hour.toString();
             }

             //for minutes
             if(timeOfDay.minute.toString().length==1){
               minutes="0"+timeOfDay.minute.toString();
             }else{
               minutes=timeOfDay.minute.toString();
             }
             time = hour+":"+minutes+":00";
             try {
               // String formattedDate = DateFormat('yyyy-MM-dd H:mm:ss').format(DateTime.parse(day + " " + time));
               t = DateTime.parse(day + " " + time);
             }catch(e){
               print(e);
             }

             print('selected time $t');
           });

         } else {
           Fluttertoast.showToast(
               msg: "Please select proper time",
               toastLength: Toast.LENGTH_SHORT,
               gravity: ToastGravity.BOTTOM,
               timeInSecForIosWeb: 1,
               backgroundColor: Colors.green,
               textColor: Colors.white,
               fontSize: 16.0);
         }


     }

  }
}
