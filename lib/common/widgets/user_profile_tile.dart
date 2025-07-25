
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/image_strings.dart';
import 'circular_image.dart';

class EUserProfileTile extends StatelessWidget {
  const EUserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    // final controller = UserController.instance;
    return ListTile(
      leading: const ECircularImage(
        image: EImages.user1,
        width: 50,
        height: 50,
        padding: 0,
      ),
      title: Text(
        // controller.user.value.fullName,
        'Admin',
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .apply(color: EColors.white),
      ),
      subtitle: Text(
        // controller.user.value.email,
        'it.attendzone@gmail.com',
        style:
        Theme.of(context).textTheme.bodyMedium!.apply(color: EColors.white),
      ),
      trailing: IconButton(
          onPressed: onPressed,
          icon: const Icon(
            Iconsax.edit,
            color: Colors.white,
          )),
    );
  }
}
