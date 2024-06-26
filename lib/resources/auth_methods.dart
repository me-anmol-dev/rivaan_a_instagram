import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rivaan_a_instagram/resources/storage_methods.dart';

import '../models/user.dart' as model;

class AuthMethods {
  // Instantiate Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // (1) Getting User Info through Model
  Future<model.User> getUserDetails() async {
    // User currentUser = _auth.currentUser!;

    // Step 1: Get Snapshot
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();
    // Step 2: Download data to User Model
    return model.User.fromSnap(snap);
  }

  // (2) Sign Up
  Future<String> userSignUp({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occurred';

    try {
      // Step 1: Sign Up
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      debugPrint(cred.user!.uid);

      // Step 2: Upload Profile Picture
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePic', file, false);

      // Before toJson was passing this
      // {
      // 'uid': cred.user!.uid,
      // 'username': username,
      // 'email': email,
      // 'bio': bio,
      // 'followers': [],
      // 'following': [],
      // 'photoUrl': photoUrl,
      // }

      // Step 3: Setting User to database
      model.User user = model.User(
        uid: cred.user!.uid,
        username: username,
        email: email,
        bio: bio,
        followers: [],
        following: [],
        photoUrl: photoUrl,
      );

      await _firestore.collection('users').doc(cred.user!.uid).set(
            user.toJson(),
          );
      res = 'success';
    } on FirebaseException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 characters';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// (3) Sign In
  Future<String> logInUser(
      {required String email, required String password}) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // (4) SignOut
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
