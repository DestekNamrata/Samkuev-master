import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PaymentDone extends StatefulWidget {
  String? mobile;
  PaymentDone({Key? key, @required this.mobile}) : super(key: key);

  @override
  _PaymentDoneState createState() => _PaymentDoneState();
}

class _PaymentDoneState extends State<PaymentDone> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
        const Duration(seconds: 5), () => Get.toNamed("/TimerScreen"));
    // const Duration(seconds: 5),
    // () => Get.toNamed("/home"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 0.08.sh,
            ),
            Center(
              child: Image.asset(
                "lib/assets/images/Payment Done Illustration-1.png",
              ),
            ),
            SizedBox(
              height: 0.03.sh,
            ),
            const Text('Payment Done',
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Colors.black)),
            SizedBox(
              height: 0.04.sh,
            ),
            Text(widget.mobile.toString(),
                style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: Colors.black)),
            SizedBox(height: 0.05.sh),
            Center(
              child: Image.asset(
                  "lib/assets/images/Payment Done Illustration.png"),
            ),
          ],
        ),
      ),
    );
  }
}
