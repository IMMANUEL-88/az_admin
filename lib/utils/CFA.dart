import 'package:admin/utils/constants/colors.dart';
import 'package:admin/utils/constants/sizes.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';
import '../functions/MPF.dart';

String timein = '09:00:00';
String timeout = '16:00:00';

class CFA extends StatefulWidget {
  final String userid;
  final String name;
  final DateTime date;
  final Function(String) removeFromList;

  const CFA({
    required this.userid,
    required this.name,
    required this.date,
    required this.removeFromList,
    super.key,
  });

  @override
  State<CFA> createState() => _CFAState();
}

class _CFAState extends State<CFA> {
  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      height: screenHeight * .15,
      decoration: BoxDecoration(
        color: dark? EColors.dark: EColors.light,
        borderRadius: BorderRadius.circular(10),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey.withOpacity(0.3),
        //     spreadRadius: 3,
        //     blurRadius: 7,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      padding: const EdgeInsets.all(ESizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "User ID: ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: dark? Colors.white :  EColors.dark,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.userid,
                style: TextStyle(
                  color: dark? Colors.white :  EColors.dark,
                ),
              ),
              const SizedBox(height: ESizes.sm,),
              Text(
                "Username:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: dark? Colors.white :  EColors.dark,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.name,
                style: TextStyle(
                  color: dark? Colors.white :  EColors.dark,
                ),
              ),
            ],
          ),
          Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Text(
              //   "Username",
              //   style: TextStyle(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 16,
              //     color: Colors.white,
              //   ),
              // ),
              // const SizedBox(height: 5),
              // Text(
              //   widget.name,
              //   style: const TextStyle(
              //     color: Colors.white,
              //   ),
              // ),
              // const SizedBox(height: 25,),
              SizedBox(
                width: EHelperFunctions.screenWidth()*0.3, // Set the desired width
                height: 50, // Set the desired height
                child: ElevatedButton(
                  onPressed: () async {
                    await MPF().updateTO(widget.userid, widget.date.toString(), timeout, timein);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Marked ${widget.userid} as Present"),
                      duration: const Duration(seconds: 2),
                    ));
                    widget.removeFromList(widget.userid);
                  },
                  child: Text(
                    'Mark Present',
                    style: TextStyle(
                      color: dark ? EColors.dark : EColors.dark,
                      fontSize: 15,
                    ),
                  ),
                ),
              )

            ],
          ),
        ],
      ),
    );
  }
}
