import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/models/userModel.dart';
import 'package:instagram_flutter/resources/stroage_method.dart';

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

        String photoUrl = await StorageMethods().uploadImagetoStroage(
          'profilePics',
          file,
          false,
        );

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
        print(err);
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
        print(err.code);
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<void> signOut(context) async {
    await _auth.signOut();
  }
}
