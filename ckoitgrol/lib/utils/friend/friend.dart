import 'package:flutter/material.dart';
import 'package:ckoitgrol/entities/user_entity.dart';

class Friend extends StatelessWidget {
  final UserEntity user;
  final bool isFollowing;
  final bool isFollowersTab;
  final VoidCallback onFollowToggle;

  const Friend({
    super.key,
    required this.user,
    required this.isFollowing,
    this.isFollowersTab = false,
    required this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            user.photoURL != null ? NetworkImage(user.photoURL!) : null,
        child: user.photoURL == null ? const Icon(Icons.person) : null,
      ),
      title: Text(user.username ?? ''),
      trailing: isFollowersTab && isFollowing
          ? null
          : IconButton(
              icon: Icon(isFollowing ? Icons.person_remove : Icons.person_add),
              onPressed: onFollowToggle,
            ),
    );
  }
}
