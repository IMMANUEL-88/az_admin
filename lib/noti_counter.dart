import 'package:get/get.dart';
import 'package:admin/pages/Announcemt.dart';
import 'package:admin/utils/constants/colors.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ENotiCounterIcon extends StatelessWidget {
  const ENotiCounterIcon({
    super.key,
    required this.onPressed,
    this.iconColor,
  });

  final VoidCallback onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Stack(
      children: [
        IconButton(
          onPressed: () => Get.to(() => const Announcement()),
          icon: Icon(
            Iconsax.notification,
            color: dark ? EColors.white : EColors.black,
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              color: EColors.primaryColor,
              borderRadius: BorderRadius.circular(
                100,
              ),
            ),
            child: Center(
              child: Text(
                '2',
                style: Theme.of(context).textTheme.labelLarge!.apply(
                    color: dark ?  EColors.white : EColors.black,
                    fontSizeFactor: 1, fontWeightDelta: 10),
              ),
            ),
          ),
        )
      ],
    );
  }
}
