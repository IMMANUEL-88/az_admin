import 'package:admin/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper_functions/helper_functions.dart';
import 'animation_loader.dart';

class EFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  /// Optionally specify a duration after which the loading dialog should close automatically.
  static void openLoadingDialog(String text) {
    // Remove focus from any input fields
    // FocusScope.of(Get.context!).unfocus();
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false, // Disable popping with the back button
        child: Container(
          color: Colors.white.withValues(
            alpha: 0.6,
          ),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EAnimationLoaderWidget(
                  text: text,
                  image:
                      "assets/animations/fingerprint.json", // Pass the image parameter here
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Automatically close the dialog after the specified duration
    // if (duration != null) {
    //   Future.delayed(duration, () {
    //     if (Get.isDialogOpen!) {
    //       stopLoading();
    //     }
    //   });
    // }
  }

  static void stopLoading() {
    if (Navigator.canPop(Get.overlayContext!)) {
      Navigator.of(Get.overlayContext!).pop();
    }
  }
}
