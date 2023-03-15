import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class CategoryProductItemShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 0.8.sw,
          height: 283,
          margin: EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: <Widget>[
              // ListTile(
              //   tileColor: Colors.grey,
              // )
              Container(
                width: 0.8.sw,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                height: 223,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 0.8.sw,
                          height: 100,
                          color: Colors.white,
                        ),
                        Container(
                          height: 16,
                          color: Colors.white,
                          width: 0.8.sw,
                        ),
                        Container(
                          width: 40,
                          height: 20,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Container(
                  height: 60,
                  width: (1.sw - 38),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 20,
                            width: (1.sw - 200),
                            color: Colors.white,
                          ),
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18)),
                          )
                        ],
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }
}
