import 'package:admin/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import 'helper_functions/helper_functions.dart';

class TFD extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool obscuretext;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final ValueChanged<String>? onFieldSubmitted; // Add this line

  const TFD({
    super.key,
    required this.hintText,
    required this.obscuretext,
    this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.onFieldSubmitted, // Add this line
  }); // Add this line

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return TextField(
      controller: controller,
      obscureText: obscuretext,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: dark? EColors.dark: EColors.light,
        filled: true,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
        labelText: hintText,
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSubmitted: onFieldSubmitted, // Add this line
    );
  }
}
