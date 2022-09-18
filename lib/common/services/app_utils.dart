import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class AppUtil {
  static Future<String> uploadFile({
    required bool isPost,
    required File file,
    String? updateFileUrl,
  }) async {
    if (updateFileUrl != null) {
      await deleteFile(updateFileUrl);
    }

    final storageRef = FirebaseStorage.instance.ref();

    var imageRef = (isPost)
        ? storageRef.child("post/${file.path.split('/').last}")
        : storageRef.child("userDP/${file.path.split('/').last}");

    try {
      await imageRef.putFile(file);
    } on Exception catch (_) {
      // ...
    }
    return await imageRef.getDownloadURL();
  }

  static Future<void> deleteFile(String url) async {
    final storageRef = FirebaseStorage.instance.refFromURL(url);

    try {
      await storageRef.delete();
    } on Exception catch (_) {
      // ...
    }
    return;
  }
}
