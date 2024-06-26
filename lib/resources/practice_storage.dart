import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMet {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add Image to Firebase Storage
  Future<String> uploadImageToStorage(
      String folder, Uint8List file, bool isPost) async {
    Reference ref = _storage.ref().child(folder).child(_auth.currentUser!.uid);

    if (isPost) {
      String uuId = const Uuid().v1();
      ref = ref.child(uuId);
    }

    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
