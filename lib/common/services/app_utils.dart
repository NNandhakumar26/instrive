import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AppUtil {
  Future<XFile?> chooseFile() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future<String> uploadFile(XFile image) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

// Create a reference to "mountains.jpg"
    final mountainsRef = storageRef.child("mountains.jpg");

// Create a reference to 'images/mountains.jpg'
    final mountainImagesRef = storageRef.child("images/mountains.jpg");
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.absolute}/file-to-upload.png';
    File file = File(filePath);

    try {
      await mountainsRef.putFile(file);
    } on Exception catch (e) {
      // ...
    }
    return await mountainsRef.getDownloadURL();

    // final storageReference = FirebaseStorage.instance
    //     .ref()
    //     .child('chats/${Path.basename(image.path)}}');
    // final uploadTask = storageReference.putFile(File(image.path));
    // await uploadTask.onComplete;
    // print('File Uploaded');
    // return storageReference.getDownloadURL();
  }
}
