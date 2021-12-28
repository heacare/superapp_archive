import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hea/models/user.dart';
import 'package:hea/providers/auth.dart';

class UserRepo {
  final collection = FirebaseFirestore.instance.collection("users")
      .withConverter<User>(
        fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson());

  Future<User?> get(String userId) async {
    final users = await collection.where("id", isEqualTo: userId).get();
    return users.docs.isEmpty ? null : users.docs[0].data();
  }

  Future<User?> getCurrent() async {
    final authUser = Authentication().currentUser();
    if (authUser == null) return null;
    return await get(authUser.uid);
  }

  void insert(User user) async {
    await collection.add(user);
  }
}