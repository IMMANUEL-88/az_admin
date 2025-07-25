import 'dart:convert';
import 'dart:io';

import 'package:admin/Api/Api.dart';
import 'package:admin/common/widgets/appbar.dart';
import 'package:admin/utils/TXFB.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin/functions/addusr.dart';

import '../common/styles/spacing_style.dart';
import '../utils/constants/colors.dart';
import '../utils/constants/sizes.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _useridController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  File? _image;
  String _base64Image='';

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: EAppBar(
        title: Text(
          'Register New User',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Iconsax.user_add,
              weight: 10,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: ESpacingStyle.paddingWithAppBarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _useridController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: 'User ID',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields),
              TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.global),
                  labelText: 'IP Address',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwInputFields),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.password_check),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: ESizes.spaceBtwSections),

              // Replacing the ElevatedButton with GestureDetector and custom Container
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: dark ? Colors.grey[850] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: EColors.primaryColor,
                      width: 2.0,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, color: EColors.primaryColor),
                      SizedBox(width: 10),
                      Text(
                        "Add User Image",
                        style: TextStyle(
                          color: EColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: ESizes.md,),
              _image != null
                  ? Image.file(
                _image!,
                height: 100,
              )
                  : Container(),
              const SizedBox(height: ESizes.spaceBtwSections),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    _addUser(
                      _useridController.text,
                      _usernameController.text,
                      _passwordController.text,
                      _ipController.text,
                      _emailController.text,
                    );
                  },
                  label: Text(
                    'Upload User Profile',
                    style: TextStyle(
                      color: dark ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  icon: Icon(Icons.cloud_upload, color: dark? EColors.dark: EColors.light,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
        _base64Image = base64Encode(_image!.readAsBytesSync());
      });
    }
  }

  Future<void> _addUser(String userid, String username, String password, String ip, String email) async {
    try {
      if (_base64Image.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please pick an image"),
          duration: Duration(seconds: 2),
        ));
        return;
      }
      await AddUser().addData(userid, username, password, ip, email, _base64Image);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("User Added Successfully"),
        duration: Duration(seconds: 2),
      ));
      Navigator.of(context).pop();
      if (kDebugMode) {
        print('User added successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to add user: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Failed to add user"),
        duration: Duration(seconds: 2),
      ));
    }
  }
}
