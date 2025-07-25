import 'package:admin/navigation_pages/home_page.dart';
import 'package:admin/navigation_pages/profile_screen.dart';
import 'package:admin/pages/Projects.dart';
import 'package:admin/pages/Users.dart';
import 'package:admin/pages/adduser.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/constants/colors.dart';
import '../utils/helper_functions/helper_functions.dart';

// class NavigationMenu extends StatelessWidget {
//   const NavigationMenu({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(NavigationController());
//     final darkmode = EHelperFunctions.isDarkMode(context);
//
//     return Scaffold(
//       // resizeToAvoidBottomInset: true,
//       bottomNavigationBar: Obx(
//         () => BottomNavigationBar(
//           currentIndex: controller.selectedIndex.value,
//           onTap: (index) {
//             controller.selectedIndex.value = index;
//             controller.pageController.jumpToPage(index);
//           },
//           backgroundColor: darkmode ? EColors.black : Colors.white,
//           selectedItemColor: Colors.orange,
//           unselectedItemColor: darkmode ? Colors.grey[400] : Colors.black,
//           showUnselectedLabels: true,
//           selectedLabelStyle: const TextStyle(
//             color: Colors.orange,
//             fontWeight: FontWeight.bold,
//           ),
//           unselectedLabelStyle: const TextStyle(color: Colors.orange),
//           items: const [
//             BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Home'),
//             BottomNavigationBarItem(
//                 icon: Icon(Iconsax.briefcase), label: 'Project'),
//             BottomNavigationBarItem(
//                 icon: Icon(FontAwesomeIcons.users), label: 'Users'),
//             BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
//           ],
//         ),
//       ),
//       body: PageView(
//         controller: controller.pageController,
//         onPageChanged: (index) {
//           controller.selectedIndex.value = index;
//         },
//         children: controller.screens,
//       ),
//     );
//   }
// }
//
// class NavigationController extends GetxController {
//   final Rx<int> selectedIndex = 0.obs;
//
//   // Create a PageController to manage page transitions
//   final PageController pageController = PageController();
//
//   // Explicitly declare the screens list as List<Widget>
//   final List<Widget> screens = [
//     const HomePage(), // StatefulWidget
//     const Projects(), // StatefulWidget
//     const Users(),
//     const ProfileScreen(),
//   ];
// }

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkmode = EHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => SizedBox(
          height: 70,
          child: BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: (index) {
              controller.selectedIndex.value = index;
              if (controller.pageController.hasClients) {
                controller.pageController.jumpToPage(index);
              }
            },
            backgroundColor: darkmode ? EColors.black : Colors.white,
            selectedItemColor: Colors.orange,
            unselectedItemColor: darkmode ? Colors.grey[400] : Colors.black,
            showUnselectedLabels: true,
            selectedFontSize: 14,
            unselectedFontSize: 14,
            iconSize: 26,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.briefcase),
                label: 'Projects',
              ),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.users),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.user),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          controller.selectedIndex.value = index;
        },
        children: controller.screens,
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final PageController pageController = PageController();

  final List<Widget> screens = [
    const HomePage(),
    const Projects(),
    const Users(),
    const ProfileScreen(),
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
