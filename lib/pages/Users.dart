import 'package:flutter/material.dart';
import '../Api/Api.dart';
import '../models/user_model.dart';
import 'UserDetails.dart';
import 'adduser.dart';
import '../utils/constants/colors.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  late Future<User?> _futureUser;

  @override
  void initState() {
    super.initState();
    // For demonstration, we'll fetch a single user. In a real app, you'd fetch a list.
    _futureUser = ApiService().fetchUser("some_user_id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AddUserPage()));
        },
        backgroundColor: EColors.primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<User?>(
        future: _futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final User user = snapshot.data!;
            return ListView(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserDetails(user: user)));
                  },
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person),
                  ),
                  title: Text(user.username),
                  subtitle: Text(user.email),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No user found.'));
          }
        },
      ),
    );
  }
}
