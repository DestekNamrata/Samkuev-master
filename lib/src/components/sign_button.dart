import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignButton extends StatelessWidget {
  final String? title;
  final Function() onClick;
  final bool? loading;

  SignButton({this.title, required this.onClick, this.loading = false});

  @override
  Widget build(BuildContext build) {
    return Container(
        height: 56,
        width: 1.sw,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromRGBO(69, 165, 36, 1)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.0),
              ))),
          onPressed: !loading! ? onClick : () => {},
          child: !loading!
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      child: Text(
                        title!,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: Color.fromRGBO(255, 255, 255, 1)),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
        ));
  }
}
