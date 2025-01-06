import 'package:ckoitgrol/services/firebase/fireauth_service.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:ckoitgrol/provider/posts_provider.dart';
import 'package:ckoitgrol/utils/post/post.dart';
import 'package:ckoitgrol/utils/post/post_placeholder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPosts();
    });
  }

  Future<void> _loadPosts() async {
    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId != null) {
      await context.read<PostsProvider>().loadFeedPosts(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadPosts,
      child: CustomScrollView(
        slivers: [
          Consumer<PostsProvider>(
            builder: (context, postsProvider, child) {
              if (postsProvider.isLoadingFeedPosts) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => const PostPlaceholder(),
                    childCount: 3,
                  ),
                );
              }

              if (postsProvider.error != null) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          postsProvider.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                        TextButton(
                          onPressed: _loadPosts,
                          child: Text(Translate.of(context).retry),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (postsProvider.feedPosts.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.post_add,
                          size: 48,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          Translate.of(context).noPosts,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = postsProvider.feedPosts[index];
                    return UserPost(
                      title: post.text,
                      description: post.text,
                      image: post.imageUrl,
                      grolPercentage: post.grolPercentage,
                      date: post.timestamp.toString(),
                      author: post.username,
                    );
                  },
                  childCount: postsProvider.feedPosts.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
