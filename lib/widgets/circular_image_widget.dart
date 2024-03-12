import 'package:flutter/material.dart';

import '../constants/constant_export.dart';

class CircularImageWidget extends StatelessWidget {
  const CircularImageWidget({
    super.key,
    this.imagePath = "assets/images/profile.jpg",
    this.kWidget = 150,
    this.kHeight = 150,
  });

  final String imagePath;
  final double kWidget;
  final double kHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kWidget,
      height: kHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: kTransparent,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
