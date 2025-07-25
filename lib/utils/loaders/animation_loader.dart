
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../helper_functions/helper_functions.dart';

class EAnimationLoaderWidget extends StatelessWidget {
  final String text;
  final String image;

  const EAnimationLoaderWidget({
    super.key,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image(image: AssetImage(image)),
        // CircularProgressIndicator(
        //   color: color,
        // ),
        const SizedBox(height: 20),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.apply(
            color: dark ? EColors.white : EColors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}