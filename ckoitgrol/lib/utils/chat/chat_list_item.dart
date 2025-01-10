import 'package:flutter/material.dart';
import 'package:ckoitgrol/entities/user_entity.dart';
import 'package:ckoitgrol/entities/shared_post_entity.dart';

class ChatListItem extends StatelessWidget {
  final UserEntity user;
  final SharedPostEntity lastSharedPost;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.user,
    required this.lastSharedPost,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage:
            user.photoURL != null ? NetworkImage(user.photoURL!) : null,
        child: user.photoURL == null ? const Icon(Icons.person) : null,
      ),
      title: Text(user.username ?? 'Unknown'),
      subtitle: Text(
        'Last shared: ${lastSharedPost.timestamp.toString().split('.')[0]}',
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: !lastSharedPost.isRead
          ? Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }
}
