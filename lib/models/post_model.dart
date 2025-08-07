import 'package:flutter/foundation.dart';

class Post {
  final String id;
  final String content;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.content,
    required this.timestamp,
  });

  // Factory constructor to create a Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print("Parsing Post from JSON: $json");
    }
    return Post(
      id: json['_id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  // Method to convert a Post to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
