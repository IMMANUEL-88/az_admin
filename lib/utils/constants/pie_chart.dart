import 'package:admin/utils/constants/colors.dart';
import 'package:admin/utils/constants/sizes.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class MyPieChart extends StatelessWidget {
  final double present;
  final double absent;

  const MyPieChart({
    super.key,
    required this.present,
    required this.absent,
  });

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    // Check if any of the values are negative, handle this scenario
    if (present < 0 || absent < 0) {
      return Container(
        color: Theme.of(context).colorScheme.onSurface,
        height: MediaQuery.of(context).size.height * 0.3,
        child: const Center(
          child: Text(
            'Invalid data for PieChart',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    try {
      return Column(
        children: [
          Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.2,
            child: Center(
              child: PieChart(
                swapAnimationCurve: Curves.easeInOut,
                swapAnimationDuration: const Duration(milliseconds: 2000),
                PieChartData(
                  sections: _showingSections(context),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: ESizes.defaultSpace),
          // Indicator for the pie chart
          _buildIndicator(context, color: Colors.orange, text: 'No. of Present: ${present.toInt()}'),
          _buildIndicator(context, color: Colors.red, text: 'No. of Absent: ${absent.toInt()}'),
        ],
      );
    } catch (e) {
      // Handle the error gracefully, e.g., show an error message or fallback UI
      return Container(
        color: dark ? EColors.light : EColors.light,
        height: MediaQuery.of(context).size.height * 0.3,
        child: const Center(
          child: Text(
            'Error loading pie chart',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

  List<PieChartSectionData> _showingSections(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return [
      PieChartSectionData(
        value: present,
        // Convert value to int before displaying it in the title
        title: '${present.toInt()}',
        showTitle: true,
        color: Colors.orange,
        titleStyle: GoogleFonts.ubuntu(
          color: dark ? EColors.dark : EColors.dark,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        radius: 45,
      ),
      PieChartSectionData(
        value: absent,
        // Convert value to int before displaying it in the title
        title: '${absent.toInt()}',
        showTitle: true,
        color: Colors.red,
        titleStyle: GoogleFonts.ubuntu(
          color: dark ? EColors.dark : EColors.dark,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        radius: 45,
      ),
    ];
  }

  Widget _buildIndicator(BuildContext context,
      {required Color color, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}
