import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:ckoitgrol/entities/shared_post_entity.dart';
import 'package:ckoitgrol/provider/user_data_provider.dart';
import 'package:ckoitgrol/provider/posts_provider.dart';
import 'package:ckoitgrol/entities/user_entity.dart';

class ShareDialog extends StatefulWidget {
  final String postId;
  final String currentUserId;

  const ShareDialog({
    super.key,
    required this.postId,
    required this.currentUserId,
  });

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  Set<String> sentTo = {};

  void _handleShare(UserEntity user) async {
    final sharedPost = SharedPostEntity(
      id: const Uuid().v4(),
      postId: widget.postId,
      senderId: widget.currentUserId,
      receiverId: user.uid,
      timestamp: DateTime.now(),
    );

    await context.read<PostsProvider>().sharePost(sharedPost);
    setState(() {
      sentTo.add(user.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share with',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<UserDataProvider>(
                builder: (context, provider, _) {
                  final following = provider.following ?? [];

                  if (following.isEmpty) {
                    return const Center(
                      child: Text('No followers to share with'),
                    );
                  }

                  return ListView.builder(
                    itemCount: following.length,
                    itemBuilder: (context, index) {
                      final user = following[index];
                      final isSent = sentTo.contains(user.uid);

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user.photoURL != null
                              ? NetworkImage(user.photoURL!)
                              : null,
                          child: user.photoURL == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(user.username ?? ''),
                        trailing: TextButton(
                          onPressed: isSent ? null : () => _handleShare(user),
                          child: Text(isSent ? 'Sent' : 'Send'),
                        ),
                      );
                    },
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
