import 'package:admin/graph/bar_data.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';

class BarGraph extends StatelessWidget {
  final List weeklySummary;
  const BarGraph({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    // Initialize Bar Data
    BarData myBarData = BarData(
      sunNo: weeklySummary[0],
      monNo: weeklySummary[1],
      tueNo: weeklySummary[2],
      wedNo: weeklySummary[3],
      thuNo: weeklySummary[4],
      friNo: weeklySummary[5],
      satNo: weeklySummary[6],
    );
    myBarData.initializeBarData();

    return BarChart(BarChartData(
      maxY: 100,
      minY: 0,
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) => getBottomTiles(context, value, meta),
            reservedSize: 45, // Increase this value if necessary
          ),
        ),
      ),
      barGroups: myBarData.barData.map((data) => BarChartGroupData(
        x: data.x,
        barRods: [
          BarChartRodData(
            toY: data.y,
            color: EColors.primaryColor,
            width: 25,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: 100,
              color: dark? EColors.dark: Colors.grey[200],
            ),
          ),
        ],
      )).toList(),
    ));
  }
}

Widget getBottomTiles(BuildContext context, double value, TitleMeta meta) {
  final isDarkMode = EHelperFunctions.isDarkMode(context);
  final style = TextStyle(
    color: isDarkMode ? Colors.white : Colors.black,
    fontWeight: FontWeight.normal,
    fontSize: 14,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text('S', style: style);
      break;
    case 1:
      text = Text('M', style: style);
      break;
    case 2:
      text = Text('T', style: style);
      break;
    case 3:
      text = Text('W', style: style);
      break;
    case 4:
      text = Text('T', style: style);
      break;
    case 5:
      text = Text('F', style: style);
      break;
    case 6:
      text = Text('S', style: style);
      break;
    default:
      text = Text('', style: style);
      break;
  }
  return const Text('');
}
