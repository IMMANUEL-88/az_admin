import 'package:admin/common/widgets/appbar.dart';
import 'package:admin/common/widgets/primary_header_container.dart';
import 'package:admin/common/widgets/settings_menu_tile.dart';
import 'package:admin/login.dart';
import 'package:admin/pages/Announcemt.dart';
import 'package:admin/utils/loaders/fullscreen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/widgets/section_heading.dart';
import '../common/widgets/user_profile_tile.dart';
import '../functions/prsnt.dart';
import '../pages/analytics.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';
import '../utils/helper_functions/helper_functions.dart';

class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  void toggleThemeMode() {
    // Toggle directly between light and dark mode
    if (themeMode.value == ThemeMode.dark ||
        (themeMode.value == ThemeMode.system && Get.isDarkMode)) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
    update();
  }

  bool isDarkMode(BuildContext context) {
    if (themeMode.value == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return themeMode.value == ThemeMode.dark;
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late prsnt presentData;
  late DateTime _selectedDate;
  List<Map<String, dynamic>> filteredPresentUsers = [];

  @override
  void initState() {
    super.initState();
    _selectedDate =
        DateTime.now(); // Initialize _selectedDate with current date
    fetchData(); // Fetch initial data
  }

  Future<void> fetchData() async {
    presentData = prsnt();
    await presentData.fetchData();
    _filterPresentUsersByDate(_selectedDate);
  }

  void _filterPresentUsersByDate(DateTime selectedDate) {
    filteredPresentUsers = presentData.presentUsers.where((user) {
      DateTime userDate = DateTime.parse(user['Date']);
      return userDate.year == selectedDate.year &&
          userDate.month == selectedDate.month &&
          userDate.day == selectedDate.day;
    }).toList();
    setState(() {}); // Trigger a rebuild after filtering data
  }

  // Function to get present count for the week
  List<int> getWeeklyPresentCount() {
    List<int> weeklyCount = List.filled(7, 0);
    DateTime startOfWeek = _selectedDate.subtract(
        Duration(days: _selectedDate.weekday % 7)); // Get Sunday of the week

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      int count = presentData.presentUsers.where((user) {
        DateTime userDate = DateTime.parse(user['Date']);
        return userDate.year == day.year &&
            userDate.month == day.month &&
            userDate.day == day.day;
      }).length;

      weeklyCount[i] = count;
    }

    return weeklyCount;
  }

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    final dark = EHelperFunctions.isDarkMode(context);
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Logout',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .apply(color: dark ? EColors.light : EColors.dark),
            ),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to logout?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    child: Text(
                      'Logout',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: dark ? EColors.light : EColors.dark),
                    ),
                    onPressed: () async {
                      EFullScreenLoader.openLoadingDialog("Logging out...");
                      // Clear the login state and token
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('isLoggedIn');
                      await prefs.remove('token');
                      await prefs.remove('userId');

                      await Future.delayed(Duration(seconds: 3));
                      EFullScreenLoader.stopLoading();
                      // Navigate to login page and clear navigation stack
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: ESizes.sm,
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    child: Text(
                      'Cancel',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .apply(color: dark ? EColors.light : EColors.dark),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.put(ThemeController());

    // Convert the List<int> to List<double>
    List<double> weeklyData =
        getWeeklyPresentCount().map((int value) => value.toDouble()).toList();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            EPrimaryHeaderContainer(
              child: Column(
                children: [
                  EAppBar(
                    title: Text(
                      'Profile',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  EUserProfileTile(
                    onPressed: () {},
                  ),
                  const SizedBox(
                    height: ESizes.spaceBtwSections,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(ESizes.defaultSpace),
              child: Column(
                children: [
                  const ESectionHeading(
                    title: 'Account Settings',
                    showActionButton: false,
                  ),
                  const SizedBox(
                    height: ESizes.spaceBtwItems,
                  ),
                  const ESettingsMenuTile(
                    icon: FontAwesomeIcons.userPlus,
                    title: 'Manage Users',
                    subTitle: 'Add, Remove or Modify Users',
                  ),
                  ESettingsMenuTile(
                    icon: FontAwesomeIcons.bell,
                    title: 'Manage Announcements',
                    subTitle: 'Create or Update Announcements',
                    onTap: () => Get.to(() => const Announcement()),
                  ),
                  ESettingsMenuTile(
                    icon: FontAwesomeIcons.chartColumn,
                    title: 'Analytics Dashboard',
                    subTitle: 'View usage statistics and performance metrics',
                    onTap: () => Get.to(() => const Analytics()),
                  ),
                  Obx(() {
                    return ESettingsMenuTile(
                      icon: Icons.dark_mode_rounded,
                      title: 'Dark Mode',
                      subTitle: 'Switch themes to suit your preference',
                      trailing: Switch(
                        value: themeController.isDarkMode(context),
                        onChanged: (value) {
                          themeController.toggleThemeMode();
                          Get.changeThemeMode(themeController.themeMode.value);
                        },
                      ),
                    );
                  }),
                  const SizedBox(
                    height: ESizes.spaceBtwSections,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        showLogoutConfirmationDialog(context);
                      },
                      child: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
