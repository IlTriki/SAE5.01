import 'package:ckoitgrol/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _db.collection('users').doc(uid).set({
      'uid': uid,
      ...data,
    });
  }

  Stream<DocumentSnapshot> getUserStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }

  Future<void> updateUser(UserEntity user) async {
    // check if username is modified
    final docSnapshot = await _db.collection('users').doc(user.uid).get();
    final currentUsername = docSnapshot.data()?['username'] as String?;
    // if username is modified, update the username in the posts
    if (currentUsername != user.username) {
      final posts = await _db
          .collection('posts')
          .where('userId', isEqualTo: user.uid)
          .get();
      for (var post in posts.docs) {
        await _db
            .collection('posts')
            .doc(post.id)
            .update({'username': user.username});
      }
    }
    await _db.collection('users').doc(user.uid).update(user.toJson());
  }

  Future<List<UserEntity>?> getUserFollowers(String uid) async {
    final snapshot =
        await _db.collection('users').doc(uid).collection('followers').get();
    final List<UserEntity> followers = [];
    for (var doc in snapshot.docs) {
      // get user data from uid
      final userSnapshot = await _db.collection('users').doc(doc.id).get();
      final userData =
          UserEntity.fromJson(userSnapshot.data() as Map<String, dynamic>);
      followers.add(userData);
    }
    return followers;
  }

  Future<void> followUser(String uid, String followerUid) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('following')
        .doc(followerUid)
        .set({});
  }

  Future<void> unfollowUser(String uid, String followerUid) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('following')
        .doc(followerUid)
        .delete();
  }

  Future<List<UserEntity>?> getUserFollowing(String uid) async {
    final snapshot =
        await _db.collection('users').doc(uid).collection('following').get();
    final List<UserEntity> following = [];
    for (var doc in snapshot.docs) {
      // get user data from uid
      final userSnapshot = await _db.collection('users').doc(doc.id).get();
      final userData =
          UserEntity.fromJson(userSnapshot.data() as Map<String, dynamic>);
      following.add(userData);
    }
    return following;
  }

  Future<void> removeUserFromFollowing(String uid, String followingUid) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('following')
        .doc(followingUid)
        .delete();
  }

  Future<void> removeUserFromFollowers(String uid, String followerUid) async {
    await _db
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(followerUid)
        .delete();
  }

  Future<List<UserEntity>?> getAllUsers() async {
    final snapshot = await _db.collection('users').get();
    return snapshot.docs
        .map((doc) => UserEntity.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<int> getFollowersCount(String uid) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('followers')
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  Future<int> getFollowingCount(String uid) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('following')
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  Future<int> getUserPostsCount(String uid) async {
    final snapshot = await _db
        .collection('posts')
        .where('userId', isEqualTo: uid)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  Future<void> updateUserData(UserEntity userData) async {
    // Get the current counts
    final followersCount = await getFollowersCount(userData.uid);
    final followingCount = await getFollowingCount(userData.uid);
    final postsCount = await getUserPostsCount(userData.uid);

    // Create a map of the user data including the counts
    final Map<String, dynamic> data = {
      'uid': userData.uid,
      'username': userData.username,
      'photoURL': userData.photoURL,
      'bio': userData.bio,
      'location': userData.location,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'postsCount': postsCount,
    };

    // Update the user document with all fields including counts
    await _db.collection('users').doc(userData.uid).update(data);
  }
}
