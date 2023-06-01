import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHelper {
  FirebaseStorageHelper._();

  static final FirebaseStorageHelper firebaseStorageHelper = FirebaseStorageHelper._();

  Reference storageRef = FirebaseStorage.instance.ref();

  uploadFile({required String imagePath, required String uniqueId}) {
    print("UPLOAD START++++++++++++++++++++");

    final spaceRef = storageRef.child("images/$uniqueId.jpg");
    File file = File(imagePath);

    try {
      spaceRef.putFile(file).toString();
    } catch (e) {
      print("==========================================");
      print("ERROR: $e");
      print("==========================================");
    }
  }

  Future<String> getImageURL({required String uniqueId}) async {
    print("ID: $uniqueId>>>>>>>>>>>>>>");

    String imageURL = await storageRef.child("images/$uniqueId.jpg").getDownloadURL();

    print("++++++++++++++++++++++++++++");
    print("URL: $imageURL");
    print("++++++++++++++++++++++++++++");

    return imageURL;
  }
}
