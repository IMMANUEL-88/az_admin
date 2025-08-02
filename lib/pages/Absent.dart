import 'package:admin/common/widgets/appbar.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import '../functions/prsnt.dart';
import '../utils/CFA.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';

DateTime date = _selectedDate;
var Date = '${date.year}-${date.month}-${date.day}';
late DateTime _selectedDate;
late List<Map<String, dynamic>> allUsers;

class Absent extends StatefulWidget {
  const Absent({super.key});

  @override
  _AbsentState createState() => _AbsentState();
}

class _AbsentState extends State<Absent> {
  late prsnt presentData;

  late List<Map<String, dynamic>> absentUsers;

  @override
  void initState() {
    super.initState();
    presentData = prsnt();
    allUsers = [];
    absentUsers = [];
    _selectedDate = DateTime.now();
    fetchData();
  }

  void fetchData() async {
    await presentData.fetchData();
    allUsers = presentData.allUsers;
    filterAbsentUsers(_selectedDate);
    setState(() {});
  }

  void filterAbsentUsers(DateTime selectedDate) {
    absentUsers = allUsers.where((user) {
      return !presentData.presentUsers.any((presentUser) {
        DateTime userDate = DateTime.parse(presentUser['Date']);
        return user['userId'] == presentUser['userId'] &&
            userDate.year == selectedDate.year &&
            userDate.month == selectedDate.month &&
            userDate.day == selectedDate.day;
      });
    }).toList();
  }

  void removeFromList(String userid) {
    setState(() {
      absentUsers.removeWhere((user) => user['userId'].toString() == userid);
    });
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
        filterAbsentUsers(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Absent',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: const Color(0xFF240E5A),
      //   iconTheme: const IconThemeData(color: Colors.white),
      //   actions: [

      //   ],
      // ),
      appBar: EAppBar(
        title: Text('Absent', style: Theme.of(context).textTheme.headlineMedium,),
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_today,
              color: dark? EColors.light: EColors.dark,
            ),
            onPressed: () {
              _selectDate(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(ESizes.defaultSpace),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: absentUsers.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> userData = absentUsers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: ESizes.sm
                    ),
                    child: CFA(
                      userid: userData['userId'].toString() ?? '',
                      name: userData['username'] ?? '',
                      date: _selectedDate,
                      removeFromList: removeFromList,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
