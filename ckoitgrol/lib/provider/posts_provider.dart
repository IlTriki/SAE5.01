import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ckoitgrol/entities/user_post_entity.dart';
import 'package:ckoitgrol/services/firebase/firebase_post_service.dart';
import 'package:ckoitgrol/entities/shared_post_entity.dart';
import 'package:rxdart/rxdart.dart';

class PostsProvider with ChangeNotifier {
  final FirebasePostService _postService;
  // Add cache map for profile pictures
  final Map<String, String> _profilePictureCache = {};

  List<UserPostEntity> _userPosts = [];
  List<UserPostEntity> _feedPosts = [];
  bool _isLoadingUserPosts = false;
  bool _isLoadingFeedPosts = false;
  String? _error;

  // Separate subscriptions for feed and user posts
  Map<String, StreamSubscription<UserPostEntity>> _userPostSubscriptions = {};
  Map<String, StreamSubscription<UserPostEntity>> _feedPostSubscriptions = {};

  PostsProvider(this._postService);

  // Getters
  List<UserPostEntity> get userPosts => _userPosts;
  List<UserPostEntity> get feedPosts => _feedPosts;
  bool get isLoadingUserPosts => _isLoadingUserPosts;
  bool get isLoadingFeedPosts => _isLoadingFeedPosts;
  String? get error => _error;

  // Load user's posts
  Future<void> loadUserPosts(String userId) async {
    try {
      _isLoadingUserPosts = true;
      _error = null;
      notifyListeners();

      // Cancel existing subscriptions for user posts only
      for (var subscription in _userPostSubscriptions.values) {
        subscription.cancel();
      }
      _userPostSubscriptions.clear();

      // Get initial posts
      _userPosts = await _postService.getUserPosts(userId);
      notifyListeners();

      // Set up listeners for each user post
      for (var post in _userPosts) {
        _userPostSubscriptions[post.id] =
            _postService.getPostStream(post.id).listen((updatedPost) {
          final index = _userPosts.indexWhere((p) => p.id == updatedPost.id);
          if (index != -1) {
            _userPosts[index] = updatedPost;
            notifyListeners();
          }
        });
      }
    } catch (e) {
      _error = 'Failed to load user posts: $e';
      _userPosts = [];
    } finally {
      _isLoadingUserPosts = false;
      notifyListeners();
    }
  }

  // Load feed posts
  Future<void> loadFeedPosts(String userId) async {
    try {
      _isLoadingFeedPosts = true;
      _error = null;
      notifyListeners();

      // Cancel existing subscriptions for feed posts only
      for (var subscription in _feedPostSubscriptions.values) {
        subscription.cancel();
      }
      _feedPostSubscriptions.clear();

      // Get initial posts
      _feedPosts = await _postService.getFeedPosts(userId);
      notifyListeners();

      // Set up listeners for each feed post
      for (var post in _feedPosts) {
        _feedPostSubscriptions[post.id] =
            _postService.getPostStream(post.id).listen((updatedPost) {
          final index = _feedPosts.indexWhere((p) => p.id == updatedPost.id);
          if (index != -1) {
            _feedPosts[index] = updatedPost;
            notifyListeners();
          }
        });
      }
    } catch (e) {
      _error = 'Failed to load feed posts: $e';
      _feedPosts = [];
    } finally {
      _isLoadingFeedPosts = false;
      notifyListeners();
    }
  }

  // Add new post
  Future<void> addPost(UserPostEntity post, File image) async {
    try {
      _error = null;
      await _postService.addPost(post, image);

      // Refresh user posts after adding new post
      await loadUserPosts(post.userId);
    } catch (e) {
      _error = 'Failed to add post: $e';
      notifyListeners();
    }
  }

  // Delete post
  Future<void> deletePost(String postId, String userId) async {
    try {
      _error = null;
      await _postService.deletePost(postId);

      // Remove post from local lists
      _userPosts.removeWhere((post) => post.id == postId);
      _feedPosts.removeWhere((post) => post.id == postId);

      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete post: $e';
      notifyListeners();
    }
  }

  // Refresh both user and feed posts
  Future<void> refreshPosts(String userId) async {
    await Future.wait([
      loadUserPosts(userId),
      loadFeedPosts(userId),
    ]);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<String> getPostAuthorProfilePicture(String userId) async {
    // Check cache first
    if (_profilePictureCache.containsKey(userId)) {
      return _profilePictureCache[userId]!;
    }

    // If not in cache, fetch and store
    final profilePicture =
        await _postService.getPostAuthorProfilePicture(userId);
    _profilePictureCache[userId] = profilePicture;
    return profilePicture;
  }

  // Clear cache
  void clearProfilePictureCache() {
    _profilePictureCache.clear();
    notifyListeners();
  }

  Future<void> toggleLike(String postId, String userId) async {
    try {
      await _postService.toggleLike(postId, userId);
      // No need to manually update the lists as we're using streams
    } catch (e) {
      _error = 'Failed to toggle like: $e';
      notifyListeners();
    }
  }

  bool isLikedByUser(UserPostEntity post, String userId) {
    return post.likes.contains(userId);
  }

  Future<void> sharePost(SharedPostEntity sharedPost) async {
    try {
      await _postService.sharePost(sharedPost);
    } catch (e) {
      _error = 'Failed to share post: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    // Cancel all subscriptions
    for (var subscription in _userPostSubscriptions.values) {
      subscription.cancel();
    }
    for (var subscription in _feedPostSubscriptions.values) {
      subscription.cancel();
    }
    _userPostSubscriptions.clear();
    _feedPostSubscriptions.clear();
    super.dispose();
  }

  Stream<Map<String, SharedPostEntity>> getLatestSharedPosts(String userId) {
    return Rx.combineLatest2(
      _postService.getSharedPostsStream(userId),
      _postService.getSentPostsStream(userId),
      (List<SharedPostEntity> receivedPosts, List<SharedPostEntity> sentPosts) {
        final Map<String, SharedPostEntity> latestByUser = {};

        // Process received posts
        for (var post in receivedPosts) {
          final otherUserId =
              post.senderId == userId ? post.receiverId : post.senderId;
          final existing = latestByUser[otherUserId];

          if (existing == null || existing.timestamp.isBefore(post.timestamp)) {
            latestByUser[otherUserId] = post;
          }
        }

        // Process sent posts
        for (var post in sentPosts) {
          final otherUserId = post.receiverId;
          final existing = latestByUser[otherUserId];

          if (existing == null || existing.timestamp.isBefore(post.timestamp)) {
            latestByUser[otherUserId] = post;
          }
        }

        return latestByUser;
      },
    );
  }

  Stream<List<SharedPostEntity>> getSharedPostsForChat(
    String currentUserId,
    String otherUserId,
  ) {
    return _postService.getSharedPostsStream(currentUserId).map((posts) {
      print('Posts: $posts');
      posts.forEach((post) {
        print('Post: ${post.toJson()}');
      });
      final filteredPosts = posts
          .where((post) =>
              (post.senderId == currentUserId &&
                  post.receiverId == otherUserId) ||
              (post.senderId == otherUserId &&
                  post.receiverId == currentUserId))
          .toList();
      print('Filtered posts: $filteredPosts');
      return filteredPosts;
    });
  }

  Future<UserPostEntity?> getPostById(String postId) async {
    try {
      // First check local cache
      var localPost = [..._userPosts, ..._feedPosts]
          .firstWhere((post) => post.id == postId);
      if (localPost != null) return localPost;

      // If not found locally, fetch from Firebase
      return await _postService.getPost(postId);
    } catch (e) {
      return null;
    }
  }
}
