import 'package:flutter/material.dart';

import '../constants/constant_export.dart';

class CircularImageWidget extends StatelessWidget {
  const CircularImageWidget({
    super.key,
    this.imagePath =
        "https://img.freepik.com/free-photo/cheerful-young-man-posing-isolated-grey_171337-10579.jpg?t=st=1710728041~exp=1710731641~hmac=e93976f3a5e84ce01d8ed2a985a512f890777b6491ce553fc5233c782336242c&w=2000",
    this.kWidget = 150,
    this.kHeight = 150,
    this.isNetworkImage = true,
  });

  final String imagePath;
  final double kWidget;
  final double kHeight;
  final bool isNetworkImage;

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
        child: isNetworkImage
            ? Image.network(
                imagePath,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                alignment: Alignment.center,
              )
            : Image.asset(
                imagePath,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
                alignment: Alignment.center,
              ),
      ),
    );
  }
}
