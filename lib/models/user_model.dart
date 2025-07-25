import 'post_model.dart';
import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String username;
  final String email;
  final List<Post> posts;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.posts,
  });

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print("Parsing User from JSON: $json");
    }
    var postList = json['posts'] as List;
    List<Post> posts = postList.map((i) => Post.fromJson(i)).toList();

    return User(
      id: json['_id'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      posts: posts,
    );
  }

  // Method to convert a User to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      'posts': posts.map((post) => post.toJson()).toList(),
    };
  }
}
