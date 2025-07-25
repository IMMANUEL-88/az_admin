import 'package:admin/common/widgets/appbar.dart';
import 'package:admin/utils/constants/sizes.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

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
    // Simulate network delay
    // await Future.delayed(const Duration(seconds: 1));
    // TODO: Implement a method to fetch projects from the new API
    return Future.value([]);
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
      // appBar: AppBar(
      //   title: Text(
      //     'Projects',
      //     style: TextStyle(
      //         color: Colors.white,
      //         fontFamily: GoogleFonts.lato().fontFamily,
      //         fontWeight: FontWeight.bold),
      //   ),
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   backgroundColor: Colors.deepPurpleAccent,
      // ),
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
        )),
        child: RefreshIndicator(
          color: EColors.primaryColor,
          backgroundColor: dark ? EColors.light : EColors.dark,
          onRefresh: () async {
            setState(() {
              _fetchProjectsFuture = fetchProjects(); // Refresh the data
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
              } else {
                List<Project_model> projects = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: projects.length,
                  itemBuilder: (context, index) {
                    Project_model project = projects[index];
                    return Column(
                      children: [
                        const SizedBox(
                          height: ESizes.md,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Project_Details(
                                  projectName: project.projectName,
                                  statusName: project.statusName,
                                  completionPercentage:
                                      project.completionPercentage,
                                  priority: project.priority,
                                  startDate: project.startDate,
                                  endDate: project.endDate,
                                  tasks: project.tasks,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: screenWidth * 0.35,
                            width: screenWidth * 0.90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: dark ? EColors.dark : Colors.grey[200],
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: const Color(0xFF000000),
                              //     offset: Offset.fromDirection(20, 2),
                              //     blurRadius: 3,
                              //     spreadRadius: 0,
                              //   ),
                              // ],
                            ),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align title to the left
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: ESizes.sm),
                                  Row(
                                    children: [
                                      const SizedBox(width: ESizes.sm),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: ESizes.sm),
                                        child: CircularPercentIndicator(
                                          radius: 30.0,
                                          animation: true,
                                          animationDuration: 1200,
                                          lineWidth: 10.0,
                                          percent: project.completionPercentage,
                                          circularStrokeCap:
                                              CircularStrokeCap.butt,
                                          fillColor: dark
                                              ? EColors.dark
                                              : Colors.grey[200]!,
                                          progressColor: EColors.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(
                                          width: ESizes.spaceBtwSections / 2),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 200),
                                            // Adjust the maxWidth as needed
                                            child: Text(
                                              project.projectName,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: GoogleFonts.ubuntu()
                                                    .fontFamily,
                                                fontWeight: FontWeight.bold,
                                                color: dark
                                                    ? EColors.light
                                                    : EColors.dark,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          const SizedBox(height: ESizes.sm),
                                          // Adjusted spacing here
                                          Text(
                                            project.icon ?? '',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: ESizes.sm),
                                  // Reduced spacing here
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: ESizes.sm),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: 12,
                                          width: 12,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: getCompletionColor(
                                                project.priority),
                                          ),
                                        ),
                                        const SizedBox(width: ESizes.sm),
                                        Text(project.priority ?? 'Not Set'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(height: 10),
                      ],
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

// Color functions and Project_model class remain the same as in the original code

Color getCompletionColor(String? category) {
  switch (category) {
    case 'High':
      return Colors.red.shade400;
    case 'Low':
      return Colors.green.shade400;
    case 'Medium':
      return Colors.orange.shade400;
    case 'General':
      return Colors.blue.shade400;
    default:
      return Colors.black;
  }
}

Color getStatusColor(String? category) {
  switch (category) {
    case 'Dropped':
      return Colors.red.shade400;
    case 'Done':
      return Colors.green.shade400;
    case 'Requested':
      return Colors.orange.shade400;
    case 'In progress':
      return Colors.blue.shade400;
    default:
      return Colors.black;
  }
}
