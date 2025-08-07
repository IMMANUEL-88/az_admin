import 'package:admin/common/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../noti_counter.dart';
import '../utils/constants/colors.dart';
import '../utils/helper_functions/helper_functions.dart'; // Add intl package for date formatting

class Project_Details extends StatelessWidget {
  final String projectName;
  final String statusName;
  final double completionPercentage;
  final String? priority;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> tasks;

  const Project_Details({super.key, 
    required this.projectName,
    required this.statusName,
    required this.completionPercentage,
    this.priority,
    this.startDate,
    this.endDate,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     'Project Details',
      //     style: TextStyle(
      //         color: Colors.white,
      //         fontFamily: GoogleFonts.lato().fontFamily,
      //         fontWeight: FontWeight.bold),
      //   ),
      //   backgroundColor: Colors.deepPurpleAccent,
      //   iconTheme: const IconThemeData(color: Colors.white),
      // ),
      appBar: EAppBar(title: Text('Project Details', style: Theme.of(context).textTheme.headlineMedium,),
        actions: [
          ENotiCounterIcon(
            onPressed: () {},
            iconColor: dark ? EColors.light : EColors.dark,
          ),
        ],),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(projectName, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),

                _buildDetailRow('Status:', statusName),
                _buildDetailRow('Completion:',
                    '${(completionPercentage * 100).toStringAsFixed(2)}%'),
                _buildDetailRow('Priority:', priority ?? 'N/A'),
                _buildDetailRow('Start Date:', _formatDate(startDate)),
                _buildDetailRow('End Date:', _formatDate(endDate)),

                const SizedBox(height: 10),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: tasks.length,
                //     itemBuilder: (context, index) {
                //       return ListTile(
                //         title: Text(tasks[index]),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
