import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryItemShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 80,
          child: Row(
            children: <Widget>[
              Container(
                width: 80,
                height: 20,
                color: Colors.white,
              )
            ],
          ),
        ));
  }
}
