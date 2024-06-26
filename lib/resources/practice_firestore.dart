import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rivaan_a_instagram/resources/practice_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:rivaan_a_instagram/resources/storage_methods.dart';

import '../models/posts.dart';

class FirestoreMet {
  final _firestore = FirebaseFirestore.instance;

// Upload Post
  Future<String> uploadPost(Uint8List file, String description, String uid,
      String username, String profImage) async {
    String res = 'Some error occurred';
    try {
      String photoUrl =
          await StorageMet().uploadImageToStorage('profilePic', file, true);

      String postId = Uuid().v1();

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

      await _firestore.collection('posts').doc(postId).set(post.toJson());

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

// Like Post
  Future<void> likePost(String postId, String uid, List likes) async {
    if (likes.contains(uid)) {
      _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayRemove([uid])
      });
    } else {
      _firestore.collection('posts').doc(postId).update({
        'likes': FieldValue.arrayUnion([uid])
      });
    }
  }

// Delete Post
  Future<void> deletePost(String postId) async {
    await _firestore.collection('posts').doc(postId).delete();
  }

  // Follow User
//   Future<void> followId(String uid, String followId) async {
//     DocumentSnapshot docSnapshot =
//         await _firestore.collection('users').doc(uid).get();
//
//     List following = (docSnapshot.data()! as dynamic)['following'];
//
//     if(following.contains()) {} else {}
//   }
}
