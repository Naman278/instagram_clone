import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String description;
  final String uid;
  final String username;
  final String commentId;
  final datePublished;
  final String profileImage;
  final likes;
  final String postId;

  const CommentModel({
    required this.description,
    required this.uid,
    required this.username,
    required this.commentId,
    required this.datePublished,
    required this.profileImage,
    required this.likes,
    required this.postId,
  });

  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "username": username,
        "commentId": commentId,
        "datePublished": datePublished,
        "profileImage": profileImage,
        "likes": likes,
        "postId": postId,
      };

  static CommentModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      commentId: snapshot['commentId'],
      datePublished: snapshot['datePublished'],
      profileImage: snapshot['profileImage'],
      likes: snapshot['likes'],
      postId: snapshot['postId'],
    );
  }
}
