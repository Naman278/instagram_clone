import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_flutter/models/comment.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/stroage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = "Some error occured";

    try {
      String postUrl =
          await StorageMethods().uploadImagetoStroage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
          description: description,
          uid: uid,
          username: username,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: postUrl,
          profileImage: profileImage,
          likes: []);

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Like Post
  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //Delete post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  //upload comment
  Future<String> postComment(
    String text,
    String uid,
    String username,
    String profileImage,
    String postId,
  ) async {
    String res = "Some error occured";

    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        CommentModel comment = CommentModel(
          description: text,
          uid: uid,
          username: username,
          commentId: commentId,
          datePublished: DateTime.now(),
          profileImage: profileImage,
          likes: [],
          postId: postId,
        );

        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(comment.toJson());
      } else {
        print('Empty text');
      }
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Like Comment
  Future<void> likeComments(
      String commentId, String uid, List likes, String postId) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId)
          ..collection('comments').doc(commentId).update({
            'likes': FieldValue.arrayUnion([uid]),
          });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //follow - unfollow
  Future<void> followUser(
    String currUid,
    String profUid,
    DocumentSnapshot<Map<String, dynamic>> snap,
  ) async {
    var userData = snap.data()!;
    var followers = userData['followers'];
    try {
      if (!followers.contains(currUid)) {
        await _firestore.collection('users').doc(profUid).update({
          'followers': FieldValue.arrayUnion([currUid])
        });
        await _firestore.collection('users').doc(currUid).update({
          'following': FieldValue.arrayUnion([profUid]),
        });
      } else {
        await _firestore.collection('users').doc(profUid).update({
          'followers': FieldValue.arrayRemove([currUid]),
        });
        await _firestore.collection('users').doc(currUid).update({
          'following': FieldValue.arrayRemove([profUid]),
        });
      }
      print('Hello');
      print(currUid);
      print(profUid);
      print(followers);
    } catch (e) {
      print(e.toString());
    }
  }
}
