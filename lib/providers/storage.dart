import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final _firebaseStorage = FirebaseStorage.instance;

  Future<Uint8List?> getFileData(String filename) async {
    final fileRef = _firebaseStorage.ref().child(filename);
    // 10MB limit
    return fileRef.getData();
  }

  Future<String> getFileUrl(String filename) async {
    final fileRef = _firebaseStorage.ref().child(filename);
    return fileRef.getDownloadURL();
  }

}