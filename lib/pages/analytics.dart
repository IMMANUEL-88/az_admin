import 'package:admin/common/styles/spacing_style.dart';
import 'package:admin/common/widgets/appbar.dart';
import 'package:admin/graph/bar_graph.dart';
import 'package:admin/utils/constants/colors.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
  bool _showWeeklyView = true;

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
    DateTime startOfWeek = _selectedDate.subtract(Duration(days: _selectedDate.weekday % 7));

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

  Widget _buildDateSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: EColors.primaryColor),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(Duration(days: 7));
                fetchData();
              });
            },
          ),
          GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
              );
              if (picked != null && picked != _selectedDate) {
                setState(() {
                  _selectedDate = picked;
                  fetchData();
                });
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: EHelperFunctions.isDarkMode(context)
                    ? EColors.darkContainer
                    : EColors.lightContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                DateFormat('MMM d, yyyy').format(_selectedDate),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: EHelperFunctions.isDarkMode(context)
                      ? EColors.light
                      : EColors.dark,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: EColors.primaryColor),
            onPressed: _selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))
                ? () {
                    setState(() {
                      _selectedDate = _selectedDate.add(Duration(days: 7));
                      fetchData();
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChoiceChip(
            label: Text('Weekly View'),
            selected: _showWeeklyView,
            onSelected: (selected) {
              setState(() {
                _showWeeklyView = selected;
              });
            },
            selectedColor: EColors.primaryColor,
            labelStyle: TextStyle(
              color: _showWeeklyView
                  ? Colors.white
                  : EHelperFunctions.isDarkMode(context)
                      ? EColors.light
                      : EColors.dark,
            ),
          ),
          SizedBox(width: 16),
          ChoiceChip(
            label: Text('Daily View'),
            selected: !_showWeeklyView,
            onSelected: (selected) {
              setState(() {
                _showWeeklyView = !selected;
              });
            },
            selectedColor: EColors.primaryColor,
            labelStyle: TextStyle(
              color: !_showWeeklyView
                  ? Colors.white
                  : EHelperFunctions.isDarkMode(context)
                      ? EColors.light
                      : EColors.dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context, double totalAttendance, double maxAttendance, double minAttendance) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              context,
              title: 'Total',
              value: totalAttendance.toInt(),
              icon: Icons.people_alt_outlined,
              color: EColors.primaryColor,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              context,
              title: 'Peak',
              value: maxAttendance.toInt(),
              icon: Icons.trending_up,
              color: EColors.success,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: _buildStatCard(
              context,
              title: 'Low',
              value: minAttendance.toInt(),
              icon: Icons.trending_down,
              color: EColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, {
    required String title,
    required int value,
    required IconData icon,
    required Color color,
  }) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: color),
                SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: dark ? EColors.lightGrey : EColors.darkGrey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              value.toString(),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: dark ? EColors.light : EColors.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);

    if (isLoading) {
      return Scaffold(
        appBar: EAppBar(
          title: Text('Attendance Analytics', style: Theme.of(context).textTheme.headlineMedium),
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
        title: Text('Attendance Analytics', style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          IconButton(
            onPressed: fetchData,
            icon: Icon(Icons.refresh, color: EColors.primaryColor),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: EColors.primaryColor,
        backgroundColor: dark ? EColors.light : EColors.dark,
        onRefresh: fetchData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 16),
              _buildDateSelector(context),
              SizedBox(height: 16),
              _buildViewToggle(context),
              SizedBox(height: 16),
              _buildStatsCards(context, totalAttendance, maxAttendance, minAttendance),
              SizedBox(height: 16),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 16),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Weekly Attendance Trend',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: dark ? EColors.light : EColors.dark,
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 250,
                        child: BarGraph(weeklySummary: weeklyData),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Daily Breakdown',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: dark ? EColors.light : EColors.dark,
                          ),
                        ),
                      ),
                      ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: daysOfWeek.length,
                        separatorBuilder: (context, index) => Divider(height: 1),
                        itemBuilder: (context, index) {
                          Color barColor = counts[index] == maxAttendance
                              ? EColors.success
                              : counts[index] == minAttendance
                                  ? EColors.error
                                  : EColors.warning;
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    daysOfWeek[index],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: dark ? EColors.light : EColors.dark,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: counts[index] / (maxAttendance == 0 ? 1 : maxAttendance),
                                    color: barColor,
                                    backgroundColor: dark ? EColors.darkGrey : EColors.lightGrey,
                                    borderRadius: BorderRadius.circular(8),
                                    minHeight: 24,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  '${counts[index].toInt()}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: dark ? EColors.light : EColors.dark,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: dark ? EColors.darkContainer : EColors.lightContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_outline,
                                color: EColors.primaryColor,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Total: ${totalAttendance.toInt()} persons',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: dark ? EColors.light : EColors.dark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
