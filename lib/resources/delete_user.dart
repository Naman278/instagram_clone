import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DeleteUser {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //Deleting all posts by user
  Future<void> userPostdelete() async {
    String uid = _auth.currentUser!.uid;
    var snaps =
        await _firestore.collection('posts').where('uid', isEqualTo: uid).get();

    for (QueryDocumentSnapshot snapshots in snaps.docs) {
      String postId = snapshots['postId'];
      //deleting all posts from backend
      Reference userFolderReference =
          _storage.ref().child('posts/$uid/$postId');
      await userFolderReference.delete();

      //Deleting all posts by user from firestore
      await _firestore.collection('posts').doc(snapshots['postId']).delete();
    }
  }

//deletign user from database
  Future<void> deleteData(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

//deleting user profile pic from backend
  Future<void> userPofilePicDelete(String uid) async {
    Reference profilepic = _storage.ref().child('profilePics/$uid');
    await profilepic.delete();
  }

  //remove all likes user made on other posts
  Future<void> deleteLikes() async {
    var snaps = await _firestore.collection('posts').get();
    String uid = _auth.currentUser!.uid;

    for (QueryDocumentSnapshot snapshots in snaps.docs) {
      if (snapshots['likes'].contains(uid)) {
        await _firestore.collection('posts').doc(snapshots['postId']).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      }
    }
  }

  //removing from other user's followers and following
  Future<void> unfollow() async {
    var snaps = await _firestore.collection('users').get();
    String uid = _auth.currentUser!.uid;
    for (QueryDocumentSnapshot snapshots in snaps.docs) {
      if (snapshots['followers'].contains(uid)) {
        await _firestore.collection('users').doc(snapshots['uid']).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
      }
      if (snapshots['following'].contains(uid)) {
        await _firestore.collection('users').doc(snapshots['uid']).update({
          'following': FieldValue.arrayRemove([uid]),
        });
      }
    }
  }

  //deleting all comments made by user
  Future<void> deleteComments() async {
    var snaps = await _firestore.collection('posts').get();
    String uid = _auth.currentUser!.uid;
    for (QueryDocumentSnapshot postSnap in snaps.docs) {
      var commentsSnap = await postSnap.reference.collection('comments').get();
      for (QueryDocumentSnapshot comments in commentsSnap.docs) {
        if (comments['uid'] == uid) {
          await _firestore
              .collection('posts')
              .doc(postSnap['postId'])
              .collection('comments')
              .doc(comments['commentId'])
              .delete();
        }
      }
    }
  }
}
