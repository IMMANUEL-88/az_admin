import 'package:admin/pages/Absent.dart';
import 'package:admin/pages/Present.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:admin/common/widgets/appbar.dart';
import 'package:admin/noti_counter.dart';
import 'package:admin/utils/constants/colors.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:admin/utils/constants/sizes.dart';
import 'package:get/get.dart';

import '../functions/prsnt.dart';
import '../pages/Announcemt.dart';
import '../utils/constants/image_strings.dart';
import '../graph/bar_graph.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late prsnt presentData;
  double presentNo = 0;
  final DateTime _selectedDate = DateTime.now();
  List<Map<String, dynamic>> filteredPresentUsers = [];
  List<Map<String, dynamic>> absentUsers = [];
  List<Map<String, dynamic>> allUsers = [];

  // Bar chart data
  List<double> weeklyData = [];
  bool isLoading = true;

  // State variables for animation and shimmer
  bool _isDataFetched = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    presentData = prsnt();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    // Pulse effect animation
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
      lowerBound: 0.85,  // This controls the minimum scale
      upperBound: 1.0,   // This controls the maximum scale
    )..repeat(reverse: true);

    fetchData();
    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      await presentData.fetchData();
      allUsers = presentData.allUsers;
      filteredPresentUsers = presentData.presentUsers;
      _filterPresentUsersByDate(_selectedDate);
      filterAbsentUsers(_selectedDate);

      // After data is fetched, set the state and start the animation
      setState(() {
        weeklyData = getWeeklyPresentCount();
        _isDataFetched = true;
        isLoading = false;
      });

      // Start the animation after a short delay to ensure smooth transition
      _animationController.forward();
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterPresentUsersByDate(DateTime selectedDate) {
    filteredPresentUsers = presentData.presentUsers.where((user) {
      DateTime userDate = DateTime.parse(user['Date']);
      return userDate.year == selectedDate.year &&
          userDate.month == selectedDate.month &&
          userDate.day == selectedDate.day;
    }).toList();
    setState(() {
      presentNo = filteredPresentUsers.length.toDouble();
    });
  }

  void filterAbsentUsers(DateTime selectedDate) {
    absentUsers = allUsers.where((user) {
      return !presentData.presentUsers.any((presentUser) {
        DateTime userDate = DateTime.parse(presentUser['Date']);
        return user['Userid'] == presentUser['Userid'] &&
            userDate.year == selectedDate.year &&
            userDate.month == selectedDate.month &&
            userDate.day == selectedDate.day;
      });
    }).toList();
    setState(() {});
  }

  List<double> getWeeklyPresentCount() {
    List<int> weeklyCount = List.filled(7, 0);
    DateTime startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7)); // Get Sunday of the week

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

    return weeklyCount.map((e) => e.toDouble()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    double present = presentNo;
    double absent = absentUsers.length.toDouble();

    return Scaffold(
      appBar: EAppBar(
        title: Text(
          'Home',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          ENotiCounterIcon(
            onPressed: () {},
            iconColor: dark ? EColors.light : EColors.dark,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        color: EColors.primaryColor,
        backgroundColor: dark ? EColors.light : EColors.dark,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(ESizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
              children: [
                if (isLoading)
                  AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseController.value,
                        child: Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: dark ? Colors.grey[800]! : Colors.grey[300]!,
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      );
                    },
                  )
                else
                  FadeTransition(
                    opacity: _animation,
                    child: Container(
                      height: EHelperFunctions.screenHeight() * 0.3,
                      decoration: BoxDecoration(
                        // color: dark ? EColors.dark.withOpacity(0.3) : Colors.white,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: dark? Colors.white.withOpacity(0.3): Colors.grey.withOpacity(0.3),),
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Colors.white.withOpacity(0.3),
                        //     blurRadius: 10,
                        //     offset: const Offset(0, 4), // Changes position of shadow
                        //   ),
                        // ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: ESizes.spaceBtwItems),
                        child: BarGraph(weeklySummary: weeklyData),
                      ),
                    ),
                  ),

                const SizedBox(height: ESizes.spaceBtwSections),
                _buildSectionHeader('Attendance Overview', context),
                const SizedBox(height: ESizes.spaceBtwItems),
                SizedBox(
                  height: 150,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      _buildPage(
                        text: 'Present Data',
                        context: context,
                        destination: const Present(),
                        imagePath: EImages.present1,
                      ),
                      _buildPage(
                        text: 'Absent Data',
                        context: context,
                        destination: const Absent(),
                        imagePath: EImages.present1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: ESizes.spaceBtwSections),
                _buildPageIndicator(2),
                const SizedBox(height: ESizes.spaceBtwSections),
                _buildSectionHeader('Latest Announcements', context),
                const SizedBox(height: ESizes.spaceBtwItems),
                GestureDetector(
                  onTap: () => Get.to(() => const Announcement()),
                  child: Container(
                    height: 150,
                    width: EHelperFunctions.screenWidth() * 0.9,
                    decoration: BoxDecoration(
                      color: dark ? Colors.grey[900] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: const AssetImage(EImages.present1),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          dark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.6),
                          BlendMode.dstATop,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Announcements',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                          color: dark ? EColors.light : EColors.dark,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: dark? Colors.black.withOpacity(0.5): Colors.grey.withOpacity(0.8),
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(
        color: EHelperFunctions.isDarkMode(context)
            ? EColors.light
            : EColors.dark,
      ),
    );
  }

  Widget _buildPage({
    required String text,
    required BuildContext context,
    required Widget destination,
    required String imagePath,
  }) {
    final dark = EHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () => Get.to(() => destination),
      child: Container(
        margin: const EdgeInsets.only(right: 1),
        width: EHelperFunctions.screenWidth() * 0.9,
        decoration: BoxDecoration(
          color: dark ? Colors.grey[900] : Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              dark ? Colors.black.withOpacity(0.6) : Colors.white.withOpacity(0.6),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(
              color: dark ? EColors.light : EColors.dark,
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: dark? Colors.black.withOpacity(0.5): Colors.grey.withOpacity(0.8),
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicator(int pageCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == _currentPage ? EColors.primaryColor : Colors.grey,
          ),
        ),
      ),
    );
  }
}
