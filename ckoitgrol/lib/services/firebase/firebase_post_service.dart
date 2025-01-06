import 'dart:io';

import 'package:ckoitgrol/entities/user_post_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  }

  Future<void> deletePost(String postId) async {
    await firestore.collection('posts').doc(postId).delete();
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
}
