import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';

class UserDetails extends StatelessWidget {
  final User user;

  const UserDetails({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user.email}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text('Posts:', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: user.posts.length,
                itemBuilder: (context, index) {
                  final Post post = user.posts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(post.content),
                      subtitle: Text('Posted on: ${post.timestamp.toLocal()}'),
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
