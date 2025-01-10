import 'package:ckoitgrol/entities/shared_post_entity.dart';
import 'package:ckoitgrol/entities/user_post_entity.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:ckoitgrol/entities/user_entity.dart';
import 'package:ckoitgrol/utils/post/post.dart';
import 'package:ckoitgrol/provider/posts_provider.dart';

@RoutePage()
class ChatPage extends StatelessWidget {
  final UserEntity chatUser;
  final String currentUserId;

  const ChatPage({
    super.key,
    required this.chatUser,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: chatUser.photoURL != null
                  ? NetworkImage(chatUser.photoURL!)
                  : null,
              child:
                  chatUser.photoURL == null ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 8),
            Text(chatUser.username ?? 'Chat'),
          ],
        ),
      ),
      body: StreamBuilder<List<SharedPostEntity>>(
        stream: context.read<PostsProvider>().getSharedPostsForChat(
              currentUserId,
              chatUser.uid,
            ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No shared posts yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final sharedPost = snapshot.data![index];
              return FutureBuilder<UserPostEntity?>(
                future: context
                    .read<PostsProvider>()
                    .getPostById(sharedPost.postId),
                builder: (context, postSnapshot) {
                  if (!postSnapshot.hasData) return const SizedBox.shrink();
                  final post = postSnapshot.data!;

                  return Column(
                    crossAxisAlignment: sharedPost.senderId == currentUserId
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          sharedPost.senderId == currentUserId
                              ? 'You shared'
                              : '${chatUser.username} shared',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      UserPost(
                        id: post.id,
                        title: post.title,
                        description: post.text,
                        image: post.imageUrl,
                        grolPercentage: post.grolPercentage,
                        date: post.timestamp.toString(),
                        author: post.username,
                        authorProfilePicture: '',
                        likes: post.likes,
                        currentUserId: currentUserId,
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
