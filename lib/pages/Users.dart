import 'dart:convert';
import 'dart:typed_data';
import 'package:admin/pages/adduser.dart';
import 'package:admin/utils/helper_functions/helper_functions.dart';
import 'package:flutter/material.dart';

import 'package:admin/Api/Api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import '../common/widgets/appbar.dart';
import '../utils/CFU.dart';
import '../utils/constants/colors.dart';

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  late Future<List<dynamic>?> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = Api().fetchUsers(); // Initialize _futureUsers here
  }

  @override
  Widget build(BuildContext context) {
    final dark = EHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: EAppBar(
        title: Text('Users', style: Theme.of(context).textTheme.headlineMedium),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Iconsax.user))],
      ),
      body: FutureBuilder<List<dynamic>?>(
        future: _futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Center(child: Text("Error fetching users"));
            }

            final users = snapshot.data ?? [];
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final profileData = user['profile'];
                      Uint8List? decodedBytes;

// Try to decode profile if it exists and is valid base64
                      if (profileData is String && profileData.isNotEmpty) {
                        try {
                          decodedBytes = base64Decode(profileData);
                        } catch (e) {
                          decodedBytes = null; // fallback if base64 is invalid
                        }
                      }

// Always return CFU, pass null if no profile
                      return CFU(
                        userid: user['userid'].toString(),
                        name: user['username'],
                        profile: decodedBytes,
                        removeFromList: (id) {},
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddUserPage()),
                        );
                      },
                      icon: Icon(
                        FontAwesomeIcons.userPlus,
                        color: dark ? EColors.dark : EColors.light,
                      ),
                      label: Text(
                        'Add User',
                        style: TextStyle(
                            color: dark ? Colors.black : Colors.white),
                      ),
                      // style: ElevatedButton.styleFrom(
                      //   primary: EColors.primaryColor, // Use your primary color
                      //   padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                      //   textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      // ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: EColors.primaryColor,
              ),
            );
          }
        },
      ),
    );
  }
}
