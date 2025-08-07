import 'dart:convert';

import 'package:admin/common/widgets/appbar.dart';
import 'package:admin/utils/constants/sizes.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../Api/Api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../models/project_model.dart';
import '../noti_counter.dart';
import '../utils/constants/colors.dart';
import 'project_details.dart';

class Projects extends StatefulWidget {
  const Projects({super.key});

  @override
  State<Projects> createState() => _ProjectsState();
}

class _ProjectsState extends State<Projects> {
  late Future<List<Project_model>> _fetchProjectsFuture;

Future<List<Project_model>> fetchProjects() async {
  try {
    final response = await http.get(
      Uri.parse('http://192.168.14.12:5000/api/v1/chat/projects'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Handle both array response and object with 'projects' property
      List<dynamic> projectsList = [];
      if (data is List) {
        projectsList = data;
      } else if (data is Map && data.containsKey('projects')) {
        projectsList = data['projects'] ?? [];
      }

      return projectsList.map((json) {
        try {
          return Project_model.fromJson(json as Map<String, dynamic>);
        } catch (e) {
          print('Error parsing project: $e');
          print('Problematic JSON: $json');
          // Return a default project if parsing fails
          return Project_model(
            id: '',
            projectName: 'Error loading project',
            statusName: 'Error',
            completionPercentage: 0,
            priority: 'Error',
            tasks: [],
            assignees: [],
          );
        }
      }).toList();
    } else {
      throw Exception('Failed to load projects: ${response.statusCode}');
    }
  } catch (error) {
    print('Error in fetchProjects: $error');
    throw Exception('Error fetching projects: $error');
  }
}
  @override
  void initState() {
    super.initState();
    _fetchProjectsFuture = fetchProjects();
  }

  Widget buildShimmerEffect(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ESizes.md),
      child: Shimmer.fromColors(
        baseColor: dark ? Colors.grey[600]! : Colors.grey[300]!,
        highlightColor: dark ? Colors.grey[600]! : Colors.grey[300]!,
        child: ListView.builder(
          itemCount: 6, // Number of shimmer items to show
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                // const SizedBox(
                //   height: 10,
                // ),
                Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: screenWidth * 0.35,
                      width: screenWidth * 0.95,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: dark ? EColors.dark : EColors.light),
                    ),
                  ],
                ),
                const SizedBox(
                  height: ESizes.sm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: EAppBar(
        title: Text(
          'Projects',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          ENotiCounterIcon(
            onPressed: () {},
            iconColor: dark ? EColors.light : EColors.dark,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10),
          ),
        ),
        child: RefreshIndicator(
          color: EColors.primaryColor,
          backgroundColor: dark ? EColors.light : EColors.dark,
          onRefresh: () async {
            setState(() {
              _fetchProjectsFuture = fetchProjects();
            });
          },
          child: FutureBuilder<List<Project_model>>(
            future: _fetchProjectsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return buildShimmerEffect(context);
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No projects found'),
                );
              } else {
                List<Project_model> projects = snapshot.data!;
                return ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    Project_model project = projects[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ESizes.md,
                        vertical: ESizes.sm,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Project_Details(
                                projectName: project.projectName,
                                statusName: project.statusName,
                                completionPercentage: project.completionPercentage,
                                priority: project.priority,
                                startDate: project.startDate,
                                endDate: project.endDate,
                                tasks: project.tasks,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 2,
                          color: dark ? EColors.dark : Colors.grey[200],
                          child: Padding(
                            padding: const EdgeInsets.all(ESizes.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 30.0,
                                      animation: true,
                                      animationDuration: 1200,
                                      lineWidth: 10.0,
                                      percent: project.completionPercentage / 100,
                                      circularStrokeCap: CircularStrokeCap.butt,
                                      fillColor: dark ? EColors.dark : Colors.grey[200]!,
                                      progressColor: EColors.primaryColor,
                                      center: Text(
                                        '${project.completionPercentage.toStringAsFixed(0)}%',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: dark ? EColors.light : EColors.dark,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: ESizes.spaceBtwItems),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            project.projectName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontFamily: GoogleFonts.ubuntu().fontFamily,
                                              fontWeight: FontWeight.bold,
                                              color: dark ? EColors.light : EColors.dark,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          if (project.icon != null)
                                            Text(
                                              project.icon!,
                                              style: const TextStyle(fontSize: 20),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: ESizes.sm),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 12,
                                          width: 12,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: getPriorityColor(project.priority),
                                          ),
                                        ),
                                        const SizedBox(width: ESizes.sm),
                                        Text(
                                          project.priority,
                                          style: TextStyle(
                                            color: dark ? EColors.light : EColors.dark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 12,
                                          width: 12,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            color: getStatusColor(project.statusName),
                                          ),
                                        ),
                                        const SizedBox(width: ESizes.sm),
                                        Text(
                                          project.statusName,
                                          style: TextStyle(
                                            color: dark ? EColors.light : EColors.dark,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                if (project.startDate != null || project.endDate != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: ESizes.sm),
                                    child: Text(
                                      '${project.startDate != null ? DateFormat('MMM d, y').format(project.startDate!) : 'No start date'} - '
                                      '${project.endDate != null ? DateFormat('MMM d, y').format(project.endDate!) : 'No end date'}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: dark ? Colors.grey[400] : Colors.grey[600],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

Color getPriorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return Colors.red.shade400;
    case 'medium':
      return Colors.orange.shade400;
    case 'low':
      return Colors.green.shade400;
    default:
      return Colors.grey;
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'in progress':
      return Colors.blue.shade400;
    case 'done':
      return Colors.green.shade400;
    case 'dropped':
      return Colors.red.shade400;
    case 'requested':
      return Colors.orange.shade400;
    default:
      return Colors.grey;
  }
}
