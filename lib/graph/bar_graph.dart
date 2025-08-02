import 'package:admin/graph/bar_data.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';

class BarGraph extends StatelessWidget {
  final List weeklySummary;
  const BarGraph({super.key, required this.weeklySummary});

// In BarGraph class
  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    if (weeklySummary.length != 7) {
      return Center(child: Text('Invalid weekly data format'));
    }

    // Handle empty data case
    if (weeklySummary.every((v) => v == 0)) {
      return Center(child: Text('No attendance data this week'));
    }

    // Calculate maxY safely
    double maxY;
    try {
      maxY = (weeklySummary
          .reduce((a, b) => (a as double) > (b as double) ? a : b) as double);
      maxY = maxY + 2; // Add padding
    } catch (e) {
      maxY = 10; // Default value
    }

    BarData myBarData = BarData(
      sunNo: weeklySummary[0] as double,
      monNo: weeklySummary[1] as double,
      tueNo: weeklySummary[2] as double,
      wedNo: weeklySummary[3] as double,
      thuNo: weeklySummary[4] as double,
      friNo: weeklySummary[5] as double,
      satNo: weeklySummary[6] as double,
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
              reservedSize: 30,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) =>
                  getBottomTiles(value, meta, context),
              reservedSize: 45,
            ),
          ),
        ),
        barGroups: myBarData.barData
            .map((data) => BarChartGroupData(
                  x: data.x,
                  barRods: [
                    BarChartRodData(
                      toY: data.y,
                      color: EColors.primaryColor,
                      width: 25,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        toY: maxY,
                        color: dark ? EColors.dark : Colors.grey[200],
                      ),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

Widget getBottomTiles(double value, TitleMeta meta, BuildContext context) {
  final isDarkMode = EHelperFunctions.isDarkMode(context);

  // Determine the day label based on value
  String dayLabel;
  switch (value.toInt()) {
    case 0:
      dayLabel = 'S';
      break;
    case 1:
      dayLabel = 'M';
      break;
    case 2:
      dayLabel = 'T';
      break;
    case 3:
      dayLabel = 'W';
      break;
    case 4:
      dayLabel = 'T';
      break;
    case 5:
      dayLabel = 'F';
      break;
    case 6:
      dayLabel = 'S';
      break;
    default:
      return const SizedBox.shrink();
  }

  return SideTitleWidget(
    meta: meta,
    space: 10,
    child: Text(
      dayLabel,
      style: TextStyle(
        color: isDarkMode ? Colors.white : Colors.black,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
    ),
  );
}
