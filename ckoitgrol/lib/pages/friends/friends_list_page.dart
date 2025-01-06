import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:provider/provider.dart';
import 'package:ckoitgrol/provider/user_data_provider.dart';
import 'package:ckoitgrol/entities/user_entity.dart';
import 'package:ckoitgrol/utils/friend/friend.dart';
import 'package:ckoitgrol/utils/friend/friend_placeholder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ckoitgrol/services/firebase/fireauth_service.dart';

@RoutePage()
class FriendsListPage extends StatefulWidget {
  const FriendsListPage({super.key});

  @override
  State<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<UserEntity>? _searchResults = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final userId = context.read<AuthService>().currentUser?.uid;
    if (userId != null) {
      context.read<UserDataProvider>().initializeUserData(userId);
    }
  }

  void _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final allUsers = await Provider.of<UserDataProvider>(context, listen: false)
        .fetchAllUsers();
    setState(() {
      _searchResults = allUsers?.where((user) {
        final usernameLower = user.username?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();

        return usernameLower.contains(searchLower);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    final following = userDataProvider.userData?.following;
    final followers = userDataProvider.userData?.followers;

    return RefreshIndicator(
      onRefresh: () async {
        await userDataProvider.refreshUserData();
      },
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: Translate.of(context).searchUsers,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: _searchUsers,
                  ),
                  const SizedBox(height: 20),
                  if (_searchResults != null && _searchResults!.isNotEmpty)
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: _searchResults
                                ?.map((user) => Friend(
                                      user: user,
                                      isFollowing: userDataProvider.following
                                              ?.contains(user) ??
                                          false,
                                      onFollowToggle: () {
                                        if (userDataProvider.following
                                                ?.contains(user) ??
                                            false) {
                                          userDataProvider
                                              .unfollowUser(user.uid);
                                        } else {
                                          userDataProvider.followUser(user.uid);
                                        }
                                      },
                                    ))
                                .toList() ??
                            [],
                      ),
                    ),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Theme.of(context).colorScheme.primary,
                    tabs: [
                      Tab(text: Translate.of(context).followers),
                      Tab(text: Translate.of(context).following),
                    ],
                  ),
                  Flexible(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildUserList(followers, userDataProvider, context),
                          _buildUserList(following, userDataProvider, context,
                              isFollowing: true),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(List<UserEntity>? users,
      UserDataProvider userDataProvider, BuildContext context,
      {bool isFollowing = false}) {
    if (userDataProvider.isLoading) {
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => const FriendPlaceholder(),
      );
    }

    final userList =
        isFollowing ? userDataProvider.following : userDataProvider.followers;

    if (userList == null || userList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.group,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              isFollowing
                  ? Translate.of(context).noFollowing
                  : Translate.of(context).noFollowers,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView(
      children: userList
          .map((user) => Friend(
                user: user,
                isFollowing:
                    userDataProvider.following?.any((u) => u.uid == user.uid) ??
                        false,
                isFollowersTab: !isFollowing,
                onFollowToggle: () {
                  if (isFollowing) {
                    userDataProvider.unfollowUser(user.uid);
                  } else {
                    userDataProvider.followUser(user.uid);
                  }
                },
              ))
          .toList(),
    );
  }
}
