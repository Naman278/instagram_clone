import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/config/utils.dart';
import 'package:instagram_flutter/models/userModel.dart';
import 'package:instagram_flutter/resources/delete_user.dart';
import 'package:instagram_flutter/resources/stroage_method.dart';
import 'package:instagram_flutter/screens/login_screen.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromSnap(snap);
  }

  //signing up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String userName,
    required String name,
    required String bio,
    required Uint8List file,
    required BuildContext context,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty ||
              password.isNotEmpty ||
              userName.isNotEmpty ||
              bio.isNotEmpty
          // || file != null
          ) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        String photoUrl = await StorageMethods()
            .uploadImagetoStroage('profilePics', file, false, null);

        UserModel user = UserModel(
          email: email,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          username: userName,
          name: name,
          bio: bio,
          followers: [],
          following: [],
        );
        //adding user to database
        _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );
        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'email-already-in-use') {
        res = 'Email Already in use by another account';
      } else if (err.code == 'invalid-email') {
        res = 'The email address is badly formatted.';
      } else if (err.code == 'weak-password') {
        res = 'Weak Password, Password should be at least 6 characters';
      } else {
        showSnackbar('err.code', context);
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //logging in users
  Future<String> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String res = "Some error occured";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all fields";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'INVALID_LOGIN_CREDENTIALS') {
        res = 'Invalid login Credentials';
      } else {
        showSnackbar(err.code, context);
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  //signing out
  Future<void> signOut(context) async {
    await _auth.signOut();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  //deleting user
  Future<void> deleteUser(context, String password) async {
    try {
      User currentUser = FirebaseAuth.instance.currentUser!;
      String res = await _reauthenticateAndDelete(context, password);
      if (res == 'Success') {
        await DeleteUser().userPostdelete();
        await DeleteUser().deleteLikes();
        await DeleteUser().unfollow();
        await DeleteUser().deleteComments();
        signOut(context);
        await DeleteUser().deleteData(currentUser.uid);
        await DeleteUser().userPofilePicDelete(currentUser.uid);
        await currentUser.delete();
        // Delete user data from Firestore
        // await _firestore.collection('users').doc(currentUser.uid).delete();

        // Delete user posts and associated comments
        // QuerySnapshot postsQuery = await _firestore
        //     .collection('posts')
        //     .where('uid', isEqualTo: currentUser.uid)
        //     .get();
        // for (QueryDocumentSnapshot postSnapshot in postsQuery.docs) {
        // Delete comments subcollection
        // var id = await _firestore.collection('posts').doc(postSnapshot['']);

        // .collection('comments')
        // .doc(currentUser.uid);
        // .delete();

        // Delete post
        // await _firestore.collection('posts').doc(postSnapshot.id).delete();

        // Delete post image from Firebase Storage
        // Assuming 'imageURL' is the field storing the image URL in the post document
        // String imageURL = postSnapshot.get('imageURL');
        // await FirebaseStorage.instance.refFromURL(imageURL).delete();

        // Delete user profile picture from Firebase Storage
        // Assuming 'profilePicURL' is the field storing the profile picture URL in the user document
        // String profilePicURL = currentUser.photoURL ?? '';
        // if (profilePicURL.isNotEmpty) {
        //   await FirebaseStorage.instance.refFromURL(profilePicURL).delete();
        // }

        // Finally, delete the user from Firebase Authentication
        // await currentUser.delete();
        // }
      } else {
        showSnackbar('Wrong Password', context);
      }
      // await FirebaseAuth.instance.currentUser!.delete();
    } catch (e) {}
    // https://medium.com/@Ruben.Aster/delete-user-accounts-in-flutter-apps-with-firebase-auth-de3740d3ba54
  }

  Future<String> _reauthenticateAndDelete(context, String password) async {
    try {
      User _user = _auth.currentUser!;
      AuthCredential credential = EmailAuthProvider.credential(
          email: _user.email ?? '', password: password);
      await _user.reauthenticateWithCredential(credential);
      return 'Success';
    } catch (e) {
      return "error";
    }
  }
}
