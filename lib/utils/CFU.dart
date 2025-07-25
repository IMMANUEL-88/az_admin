import 'dart:typed_data';

import 'package:admin/utils/constants/colors.dart';
import 'package:admin/utils/constants/sizes.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';

import '../pages/UserDetails.dart';

class CFU extends StatefulWidget {
  final String userid;
  final String name;
  final Uint8List profile;
  final Function(String) removeFromList; // Callback function to remove user from list

  const CFU({
    required this.userid,
    required this.name,
    required this.profile,
    required this.removeFromList,
    super.key,
  });

  @override
  State<CFU> createState() => _CFUState();
}

class _CFUState extends State<CFU> {
  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Container(
        // color: const Color(0xFF240E5A),
      child: Container(
        // color: dark? EColors.dark: EColors.light,
        height: EHelperFunctions.screenHeight()*0.125,
        margin: const EdgeInsets.all(ESizes.sm),
        child: Card(
          color: dark? EColors.dark: EColors.light,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: MemoryImage(widget.profile),
            ),
            title: Text(widget.name),
            subtitle: Text(widget.userid),
            trailing: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                widget.removeFromList(widget.userid);
                // TODO: Re-implement navigation to UserDetails with a User object.
                // final user = await ApiService().fetchUser(widget.userid);
                // Navigator.push(context, MaterialPageRoute(builder: (context)=> UserDetails(user: user)));
              },
            ),
            // contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ),
    );
  }
}
