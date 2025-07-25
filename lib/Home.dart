import 'package:admin/pages/Projects.dart';
import 'package:admin/pages/Absent.dart';
import 'package:admin/pages/Present.dart';
import 'package:admin/pages/Announcemt.dart';
import 'package:admin/pages/adduser.dart';
import 'package:flutter/material.dart';
import 'package:admin/functions/prsnt.dart';

import 'pages/Users.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}



class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    prsnt().fetchData();
  }

  // Function to handle button tap
  void handleButtonTap(String buttonText) {
    switch (buttonText) {
      case 'Add person':
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const AddUserPage()));
        break;
      case 'Present':
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const Present()));
        break;
      case 'Absent':
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const Absent()));
        break;
      case 'Announcement':
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const Announcement()));
        break;
      case 'Users':
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const Users()));
        break;
      case 'Projects':
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const Projects()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFF240E5A),
      body: SafeArea(
        child: ListView(
          children: [Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                SizedBox(
                  height: screenHeight*.25,
                  width: screenHeight*.40,
                  child: buildButton(
                    icon: Icons.add_moderator_outlined,
                    iconcolor: const Color.fromARGB(255, 90, 90, 91),
                    name: 'ADMIN WORKSPACE',
                    iconSize: 50.0,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Evenly space buttons
                  children: [
                    buildButton(
                      icon: Icons.person,
                      iconcolor: Colors.blue,
                      name: 'Add person',
                      iconSize: 50.0,
                    ),
                    buildButton(
                      icon: Icons.wechat_outlined,
                      iconcolor: Colors.orange,
                      name: 'Announcement',
                      iconSize: 50.0,
                    ),

                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Evenly space buttons
                  children: [
                    buildButton(
                      icon: Icons.clear,
                      iconcolor: Colors.red,
                      name: 'Absent',
                      iconSize: 50.0,
                    ),
                    buildButton(
                      icon: Icons.done,
                      iconcolor: Colors.green,
                      name: 'Present',
                      iconSize: 50.0,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Evenly space buttons
                  children: [
                    buildButton(
                      icon: Icons.groups,
                      iconcolor: Colors.green,
                      name: 'Users',
                      iconSize: 50.0,
                    ),
                    buildButton(
                      icon: Icons.settings,
                      iconcolor: Colors.black,
                      name: 'Projects',
                      iconSize: 50.0,
                    ),
                  ],
                ),
              ],
            ),
          ),]
        ),
      ),
    );
  }

  // Function to build square buttons
  Widget buildButton({
    required IconData icon,
    required Color iconcolor,
    required String name,
    required double iconSize,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.width * 0.4,
      child: GestureDetector(
        onTap: () {
          handleButtonTap(name);
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 247, 247, 248),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 72, 72, 72).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: iconSize,
                color: iconcolor,
              ),
              const SizedBox(height: 10),
              Text(
                name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 26, 26, 26),),
                // style: GoogleFonts.Poppins(
                //   fontSize: 15,
                //   fontWeight: FontWeight.bold,
                //   color: const Color.fromARGB(255, 26, 26, 26),
                //),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
