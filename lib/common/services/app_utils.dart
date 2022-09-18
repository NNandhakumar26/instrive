import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AppUtil {
  static Future<XFile?> chooseFile() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

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
    } on Exception catch (e) {
      // ...
    }
    return await imageRef.getDownloadURL();
  }

  static Future<void> deleteFile(String url) async {
    final storageRef = FirebaseStorage.instance.refFromURL(url);

    try {
      await storageRef.delete();
    } on Exception catch (e) {
      // ...
    }
    return;
  }
}
