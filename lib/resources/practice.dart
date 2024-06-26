import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rivaan_a_instagram/models/posts.dart';
import 'package:rivaan_a_instagram/resources/practice_storage.dart';
import 'package:rivaan_a_instagram/utilities/utilities.dart';
import 'package:uuid/uuid.dart';
import '../models/user.dart' as model;

class AuthM {
  // Instantiate Firebase
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // (1) Getting User Info through Model
  Future<model.User> getUserInfo() async {
    // Step 1: Get Snapshot
    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

    // Step 2: Download data to User Model
    return model.User.fromSnap(snapshot);
  }

  // (2) Sign Up
  Future<String> signUp({
    required String email,
    required String username,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    // Step 1: Declare return String
    String res = 'Some Error Occurred';

    // Step 2: Check on variables
    if (email.isNotEmpty ||
        password.isNotEmpty ||
        username.isNotEmpty ||
        bio.isNotEmpty ||
        file != null) {
      if (file == null) return 'Pic not found';

      // Step 3: Signing Up
      try {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        debugPrint(cred.user!.uid);

        // Step 4: Upload Profile Picture
        String profileUrl =
            await StorageMet().uploadImageToStorage('profilePic', file, false);

        // Step 5: Setting User to database
        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          bio: bio,
          photoUrl: profileUrl,
          followers: [],
          following: [],
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = 'Success';
      } catch (err) {
        res = err.toString();
      }
    }
    return res;
  }

// (3) Sign In
  Future<String> signIn(
      {required String email, required String password}) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      } else {
        res = 'Check username and Password';
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

class FirestoreMeths {
  final _firestore = FirebaseFirestore.instance;
  final _postRef = FirebaseFirestore.instance.collection('posts');
  final _userRef = FirebaseFirestore.instance.collection('users');

  // (1) Upload Post
  Future<bool> uploadPost({
    context,
    required Uint8List file,
    required String description,
    required String uid,
    required String username,
    required String profImage,
  }) async {
    bool res = false;

    try {
      // Upload Post Pic
      String photoUrl =
          await StorageMet().uploadImageToStorage('posts', file, true);

      // Upload Post Data to Firestore
      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );

      _postRef.doc(postId).set(post.toJson());

      res = true;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    return res;
  }

  // (2) Like Post
  Future<void> likePost({
    required List likes,
    required String uid,
    required String postId,
  }) async {
    try {
      if (likes.contains(uid)) {
        await _postRef.doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _postRef.doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // (3) Delete Post
  Future<bool> deletePost({required String postId, required context}) async {
    bool res = false;

    try {
      await _postRef.doc(postId).delete();
      res = true;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    return res;
  }

  // (4) Add Comment to Posts
  Future<String> postComment({
    required context,
    required String postId,
    required String text,
    required String uid,
    required String name,
    required String profPic,
  }) async {
    String res = 'An error Occurred';

    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();

        await _postRef.doc(postId).collection('comments').doc(commentId).set({
          'profPic': profPic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
      } else {
        res = 'Please check all the Fields';
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    return res;
  }

  // (5) Follow Users
  Future<void> followUser(
      {required context, required String uid, required String followId}) async {
    DocumentSnapshot snap = await _userRef.doc(uid).get();
    List following = (snap.data()! as dynamic)['following'];

    try {
      // Unfollow
      if (following.contains(followId)) {
        await _userRef.doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _userRef.doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
        // Follow
      } else {
        await _userRef.doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _userRef.doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }
}
