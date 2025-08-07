
import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helper_functions/helper_functions.dart';

class ECircularImage extends StatelessWidget {
  const ECircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backgroundColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = ESizes.sm,
    this.isNetworkImage = false,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
// If image background color is null then switch it to light and dark mode color design.
          color: backgroundColor ??
              (EHelperFunctions.isDarkMode(context)
                  ? EColors.black
                  : EColors.white),
          borderRadius: BorderRadius.circular(100),
        ), // BoxDecoration
        child: Center(
          child: Image(
            fit: fit,
            image: isNetworkImage
                ? NetworkImage(image)
                : AssetImage(image) as ImageProvider,
            color: overlayColor,
          ),
        ));
  }
}
