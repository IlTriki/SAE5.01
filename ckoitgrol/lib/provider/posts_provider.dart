import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ckoitgrol/entities/user_post_entity.dart';
import 'package:ckoitgrol/services/firebase/firebase_post_service.dart';

class PostsProvider with ChangeNotifier {
  final FirebasePostService _postService;

  List<UserPostEntity> _userPosts = [];
  List<UserPostEntity> _feedPosts = [];
  bool _isLoadingUserPosts = false;
  bool _isLoadingFeedPosts = false;
  String? _error;

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

      _userPosts = await _postService.getUserPosts(userId);
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

      _feedPosts = await _postService.getFeedPosts(userId);
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

  // Reset provider state
  void reset() {
    _userPosts = [];
    _feedPosts = [];
    _isLoadingUserPosts = false;
    _isLoadingFeedPosts = false;
    _error = null;
    notifyListeners();
  }
}
