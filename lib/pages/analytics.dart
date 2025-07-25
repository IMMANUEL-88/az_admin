import 'package:admin/common/styles/spacing_style.dart';
import 'package:admin/common/widgets/appbar.dart';
import 'package:admin/graph/bar_graph.dart';
import 'package:admin/utils/constants/colors.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../functions/prsnt.dart';
import '../utils/constants/sizes.dart';

class Analytics extends StatefulWidget {
  const Analytics({super.key});

  @override
  State<Analytics> createState() => _AnalyticsState();
}

class _AnalyticsState extends State<Analytics> {
  List<double> weeklyData = [];
  late prsnt presentData;
  late DateTime _selectedDate;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      presentData = prsnt();
      await presentData.fetchData();
      _filterPresentUsersByDate(_selectedDate);
      setState(() {
        weeklyData = getWeeklyPresentCount();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterPresentUsersByDate(DateTime selectedDate) {
    presentData.presentUsers.where((user) {
      DateTime userDate = DateTime.parse(user['Date']);
      return userDate.year == selectedDate.year &&
          userDate.month == selectedDate.month &&
          userDate.day == selectedDate.day;
    }).toList();
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

    if (isLoading) {
      return Scaffold(
        appBar: EAppBar(
          title: Text('Analytics', style: Theme.of(context).textTheme.headlineMedium),
          actions: [IconButton(onPressed: () {}, icon: const Icon(FontAwesomeIcons.chartColumn))],
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: EColors.primaryColor,
            backgroundColor: dark ? EColors.light : EColors.dark,
          ),
        ),
      );
    }

    List<String> daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<double> counts = weeklyData;
    double totalAttendance = counts.reduce((a, b) => a + b);
    double maxAttendance = counts.reduce((a, b) => a > b ? a : b);
    double minAttendance = counts.reduce((a, b) => a < b ? a : b);

    return Scaffold(
      appBar: EAppBar(
        title: Text('Analytics', style: Theme.of(context).textTheme.headlineMedium),
        actions: [IconButton(onPressed: () {}, icon: const Icon(FontAwesomeIcons.chartColumn))],
      ),
      body: RefreshIndicator(
        color: EColors.primaryColor,
        backgroundColor: dark? EColors.light: EColors.dark,
        onRefresh: fetchData,
        child: Padding(
          padding: ESpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              SizedBox(
                height: EHelperFunctions.screenHeight() * 0.3,
                child: BarGraph(weeklySummary: weeklyData),
              ),
              const SizedBox(height: ESizes.spaceBtwSections),
              Expanded(
                child: ListView.builder(
                  itemCount: daysOfWeek.length,
                  itemBuilder: (context, index) {
                    Color barColor = counts[index] == maxAttendance
                        ? EColors.success
                        : counts[index] == minAttendance
                        ? EColors.error
                        : EColors.warning;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Text(
                          '${daysOfWeek[index]}: ${counts[index].toInt()} person(s)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: dark ? EColors.light : EColors.dark,
                          ),
                        ),
                        subtitle: LinearProgressIndicator(
                          value: counts[index] / maxAttendance,
                          color: barColor,
                          backgroundColor: EColors.lightGrey,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total Present for the Week: ${totalAttendance.toInt()} persons',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: dark ? EColors.light : EColors.dark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
