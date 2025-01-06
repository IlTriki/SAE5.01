import 'package:ckoitgrol/entities/user_post_entity.dart';

class UserEntity {
  final String uid;
  final String? username;
  final String? photoURL;
  final String? bio;
  final String? location;
  final List<UserEntity>? followers;
  final List<UserEntity>? following;
  final List<UserPostEntity>? posts;
  final int? followersCount;
  final int? followingCount;
  final int? postsCount;

  UserEntity({
    required this.uid,
    this.username,
    this.photoURL,
    this.bio,
    this.location,
    this.followers,
    this.following,
    this.posts,
    this.followersCount,
    this.followingCount,
    this.postsCount,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      uid: json['uid'] as String,
      username: json['username'] as String?,
      photoURL: json['photoURL'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      followers: json['followers'] as List<UserEntity>?,
      following: json['following'] as List<UserEntity>?,
      posts: json['posts'] as List<UserPostEntity>?,
      followersCount: json['followersCount'] as int?,
      followingCount: json['followingCount'] as int?,
      postsCount: json['postsCount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'photoURL': photoURL,
      'bio': bio,
      'location': location,
      'followers': followers?.map((user) => user.toJson()).toList(),
      'following': following?.map((user) => user.toJson()).toList(),
      'posts': posts?.map((post) => post.toJson()).toList(),
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
    };
  }

  UserEntity copyWith({
    String? uid,
    String? username,
    String? photoURL,
    String? bio,
    String? location,
    List<UserEntity>? followers,
    List<UserEntity>? following,
    List<UserPostEntity>? posts,
    int? followersCount,
    int? followingCount,
    int? postsCount,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      photoURL: photoURL ?? this.photoURL,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      postsCount: postsCount ?? this.postsCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEntity &&
          runtimeType == other.runtimeType &&
          uid == other.uid;

  @override
  int get hashCode => uid.hashCode;
}
