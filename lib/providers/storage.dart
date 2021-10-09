import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final _firebaseStorage = FirebaseStorage.instance;

  Future<String> getFileUrl(String filename) async {
    final fileRef = _firebaseStorage.ref().child(filename);
    return fileRef.getDownloadURL();
  }

}