import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hea/models/content.dart';

class ContentRepo {
  final collection = FirebaseFirestore.instance.collection("content")
    .withConverter<Content>(
      fromFirestore: (snap, _) => Content.fromJson(snap.data()!, snap.id),
      toFirestore: (content, _) => content.toJson()
    );

  Stream<QuerySnapshot<Content>> getAll() {
    return collection.snapshots();
  }
}