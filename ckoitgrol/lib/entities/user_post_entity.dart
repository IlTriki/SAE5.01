import 'package:cloud_firestore/cloud_firestore.dart';

class UserPostEntity {
  final String id;
  final String userId;
  final String username;
  final String title;
  final String text;
  final String imageUrl;
  final double grolPercentage;
  final DateTime timestamp;

  UserPostEntity({
    required this.id,
    required this.userId,
    required this.username,
    required this.title,
    required this.text,
    required this.imageUrl,
    required this.grolPercentage,
    required this.timestamp,
  });

  UserPostEntity copyWith({
    String? imageUrl,
    double? grolPercentage,
  }) {
    return UserPostEntity(
      id: id,
      userId: userId,
      username: username,
      title: title,
      text: text,
      imageUrl: imageUrl ?? this.imageUrl,
      grolPercentage: grolPercentage ?? this.grolPercentage,
      timestamp: timestamp,
    );
  }

  factory UserPostEntity.fromJson(Map<String, dynamic> json) {
    return UserPostEntity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      username: json['username'] as String,
      title: json['title'] as String,
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String,
      grolPercentage: json['grolPercentage'] as double,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'title': title,
      'text': text,
      'imageUrl': imageUrl,
      'grolPercentage': grolPercentage,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
