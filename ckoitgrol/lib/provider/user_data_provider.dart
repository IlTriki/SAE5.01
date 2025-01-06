import 'package:ckoitgrol/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:ckoitgrol/services/firebase/firestore_service.dart';

class UserDataProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  UserEntity? _userData;
  List<UserEntity>? _followers;
  List<UserEntity>? _following;
  bool _isLoading = false;

  UserDataProvider(this._firestoreService);

  UserEntity? get userData => _userData;
  List<UserEntity>? get followers => _followers;
  List<UserEntity>? get following => _following;
  bool get isLoading => _isLoading;

  Future<void> refreshUserData() async {
    if (_userData == null) return;

    _isLoading = true;
    notifyListeners();

    final results = await Future.wait([
      _firestoreService.getUserFollowers(_userData!.uid),
      _firestoreService.getUserFollowing(_userData!.uid),
      _firestoreService.getFollowersCount(_userData!.uid),
      _firestoreService.getFollowingCount(_userData!.uid),
      _firestoreService.getUserPostsCount(_userData!.uid),
    ]);

    _followers = results[0] as List<UserEntity>?;
    _following = results[1] as List<UserEntity>?;
    final followersCount = results[2] as int;
    final followingCount = results[3] as int;
    final postsCount = results[4] as int;

    _userData = _userData!.copyWith(
      followersCount: followersCount,
      followingCount: followingCount,
      postsCount: postsCount,
    );

    _firestoreService.updateUserData(_userData!);

    _isLoading = false;
    notifyListeners();
  }

  void initializeUserData(String uid) {
    _firestoreService.getUserStream(uid).listen((snapshot) {
      _userData = UserEntity.fromJson(snapshot.data() as Map<String, dynamic>);
      refreshUserData();
      notifyListeners();
    });
  }

  void loadUserData(String uid) {
    _firestoreService.getUserStream(uid).listen((snapshot) {
      _userData = UserEntity.fromJson(snapshot.data() as Map<String, dynamic>);
      notifyListeners();
    });
  }

  void updateUserData(UserEntity user) {
    _firestoreService.updateUser(user);
    _userData = user;
    notifyListeners();
  }

  Future<void> followUser(String? uid) async {
    if (_userData?.uid == null || uid == null) {
      throw Exception(
          'Cannot follow user: Current user or target user ID is missing');
    }
    await _firestoreService.followUser(_userData!.uid, uid);
    await refreshUserData(); // Refresh the lists after following
  }

  Future<void> unfollowUser(String? uid) async {
    if (_userData?.uid == null || uid == null) {
      throw Exception(
          'Cannot unfollow user: Current user or target user ID is missing');
    }
    await _firestoreService.unfollowUser(_userData!.uid, uid);
    await refreshUserData(); // Refresh the lists after unfollowing
  }

  Future<void> removeUserFromFollowing(String? uid) async {
    if (_userData?.uid == null || uid == null) {
      throw Exception(
          'Cannot remove user from following: Current user or target user ID is missing');
    }
    await _firestoreService.removeUserFromFollowing(_userData!.uid, uid);
    await refreshUserData(); // Refresh the lists after removing
  }

  Future<void> removeUserFromFollowers(String? uid) async {
    if (_userData?.uid == null || uid == null) {
      throw Exception(
          'Cannot remove user from followers: Current user or target user ID is missing');
    }
    await _firestoreService.removeUserFromFollowers(_userData!.uid, uid);
    await refreshUserData(); // Refresh the lists after removing
  }

  Future<List<UserEntity>?> fetchAllUsers() async {
    return await _firestoreService.getAllUsers();
  }
}
