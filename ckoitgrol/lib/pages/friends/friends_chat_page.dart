import 'package:ckoitgrol/entities/shared_post_entity.dart';
import 'package:ckoitgrol/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:ckoitgrol/provider/posts_provider.dart';
import 'package:ckoitgrol/provider/user_data_provider.dart';
import 'package:ckoitgrol/utils/chat/chat_list_item.dart';
import 'package:ckoitgrol/route/router.dart';
import 'package:ckoitgrol/services/firebase/fireauth_service.dart';

@RoutePage()
class FriendsChatPage extends StatelessWidget {
  const FriendsChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthService>().currentUser?.uid;
    if (currentUserId == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: () async {
        // Force refresh by rebuilding the stream
        await Future.delayed(const Duration(milliseconds: 100));
      },
      child: StreamBuilder<Map<String, SharedPostEntity>>(
        stream:
            context.read<PostsProvider>().getLatestSharedPosts(currentUserId),
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return ListView(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No shared posts yet',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          final chatUsers = snapshot.data!;

          return ListView.builder(
            itemCount: chatUsers.length,
            itemBuilder: (context, index) {
              final userId = chatUsers.keys.elementAt(index);
              final lastSharedPost = chatUsers[userId]!;

              return FutureBuilder<UserEntity?>(
                future: context.read<UserDataProvider>().getUserById(userId),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final user = userSnapshot.data!;

                  return ChatListItem(
                    user: user,
                    lastSharedPost: lastSharedPost,
                    onTap: () {
                      context.router.push(
                        ChatRoute(
                          chatUser: user,
                          currentUserId: currentUserId,
                        ),
                      );
                    },
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
