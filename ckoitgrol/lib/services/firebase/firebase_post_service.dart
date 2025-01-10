import 'dart:io';

import 'package:ckoitgrol/entities/user_post_entity.dart';
import 'package:ckoitgrol/entities/shared_post_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class FirebasePostService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<UserPostEntity>> getUserPosts(String userId) async {
    final snapshot = await firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs
        .map((doc) => UserPostEntity.fromJson(doc.data()))
        .toList();
  }

  Future<void> addPost(UserPostEntity post, File image) async {
    final docRef = firestore.collection('posts').doc(post.id);
    await docRef.set(post.toJson());

    // Ensure the document exists before updating
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      throw Exception('Document does not exist.');
    }

    // Add image to storage
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child('posts/${post.id}.jpg');
    await storageRef.putFile(image);
    final imageUrl = await storageRef.getDownloadURL();

    // Update the document with the image URL
    await docRef.update({'imageUrl': imageUrl});
    await firestore.collection('users').doc(post.userId).update({
      'postsCount': FieldValue.increment(1),
    });
  }

  Future<void> deletePost(String postId) async {
    await firestore.collection('posts').doc(postId).delete();
  }

  Future<UserPostEntity> getPost(String postId) async {
    final snapshot = await firestore.collection('posts').doc(postId).get();
    return UserPostEntity.fromJson(snapshot.data()!);
  }

  Future<List<UserPostEntity>> getFeedPosts(String userId) async {
    final snapshot = await firestore
        .collection('posts')
        .orderBy('userId')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();
    return snapshot.docs
        .map((doc) => UserPostEntity.fromJson(doc.data()))
        .toList();
  }

  Future<String> getPostAuthorProfilePicture(String userId) async {
    final snapshot = await firestore.collection('users').doc(userId).get();
    return snapshot.data()?['photoURL'] ?? '';
  }

  Future<void> toggleLike(String postId, String userId) async {
    final postRef = firestore.collection('posts').doc(postId);

    return firestore.runTransaction((transaction) async {
      final postDoc = await transaction.get(postRef);
      if (!postDoc.exists) {
        throw Exception('Post does not exist!');
      }

      List<String> likes = List<String>.from(postDoc.data()?['likes'] ?? []);

      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }

      transaction.update(postRef, {'likes': likes});
    });
  }

  Stream<UserPostEntity> getPostStream(String postId) {
    return firestore
        .collection('posts')
        .doc(postId)
        .snapshots()
        .map((doc) => UserPostEntity.fromJson(doc.data()!));
  }

  Future<void> sharePost(SharedPostEntity sharedPost) async {
    await firestore
        .collection('shared_posts')
        .doc(sharedPost.id)
        .set(sharedPost.toJson());
  }

  Stream<List<SharedPostEntity>> getSharedPostsStream(String userId) {
    final senderStream = firestore
        .collection('shared_posts')
        .where('senderId', isEqualTo: userId)
        .snapshots();

    final receiverStream = firestore
        .collection('shared_posts')
        .where('receiverId', isEqualTo: userId)
        .snapshots();

    return Rx.combineLatest2(
      senderStream,
      receiverStream,
      (QuerySnapshot senderSnapshot, QuerySnapshot receiverSnapshot) {
        final senderPosts = senderSnapshot.docs
            .map((doc) =>
                SharedPostEntity.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        final receiverPosts = receiverSnapshot.docs
            .map((doc) =>
                SharedPostEntity.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        return [...senderPosts, ...receiverPosts];
      },
    );
  }

  Stream<List<SharedPostEntity>> getSentPostsStream(String userId) {
    return firestore
        .collection('shared_posts')
        .where('senderId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => SharedPostEntity.fromJson(doc.data()))
            .toList());
  }
}
