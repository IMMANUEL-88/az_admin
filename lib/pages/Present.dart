import 'package:admin/common/widgets/appbar.dart';
import 'package:admin/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import '../functions/prsnt.dart';
import '../utils/CFP.dart';
import '../utils/constants/sizes.dart';
import '../utils/helper_functions/helper_functions.dart';



class Present extends StatefulWidget {
  const Present({super.key});

  @override
  _PresentState createState() => _PresentState();
}

class _PresentState extends State<Present> {
  late prsnt presentData;
  late DateTime _selectedDate;
  List<Map<String, dynamic>> filteredPresentUsers = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now(); // Initialize _selectedDate with current date
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _filterPresentUsersByDate(_selectedDate); // Filter present users based on selected date
      });
    }
  }

  // Function to get present count for the week
  List<int> getWeeklyPresentCount() {
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

    return weeklyCount;
  }


  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    late var present = filteredPresentUsers.length;
    List<int> weeklyPresentCount = getWeeklyPresentCount(); // Get weekly present count

    return Scaffold(
      appBar: EAppBar(title: Text('Present', style: Theme.of(context).textTheme.headlineMedium,), actions: [IconButton(
        icon: const Icon(Icons.calendar_today),color: dark? EColors.light: EColors.dark,
        onPressed: () {
          _selectDate(context);
        },
      ),],),
      body: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: EHelperFunctions.screenWidth()*1,
              decoration: BoxDecoration(color: dark? Colors.grey[900]: Colors.grey[100],borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(ESizes.spaceBtwInputFields),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Employees Present',style: Theme.of(context).textTheme.headlineSmall),
                    Row(children: [
                      Text('$present',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.green),),
                      const SizedBox(width: 3,),
                      Text('/',style: Theme.of(context).textTheme.labelSmall),
                      const SizedBox(width: 3,),
                      Text('$all',style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.red),),
                    ],),
                  ],
                ),
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwSections,),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPresentUsers.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> userData = filteredPresentUsers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CFP(
                      name: userData['Username'] ?? '',
                      date: userData['Date'] ?? '',
                      timeIn: userData['time_in'] ?? '',
                      timeOut: userData['time_out'] ?? '',
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: ESizes.spaceBtwSections,),
            // Text('Weekly Present Count: $weeklyPresentCount'), // Display weekly present count
          ],
        ),
      ),
    );
  }
}

