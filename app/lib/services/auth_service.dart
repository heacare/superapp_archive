import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceException implements Exception {
  final String message;
  AuthServiceException({required this.message});
}

class AuthService {
  final firebaseAuth = FirebaseAuth.instance;

  User? currentUser() {
    return firebaseAuth.currentUser;
  }

  Future<String>? currentUserToken() {
    return firebaseAuth.currentUser?.getIdToken();
  }

  Future signup(String email, String password) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthServiceException(message: "Password is weak");
      } else if (e.code == 'email-already-in-use') {
        throw AuthServiceException(
            message:
                "Email is already in use - did you mean to login instead?");
      }
      throw AuthServiceException(
          message:
              "Unknown authentication error occurred in signup! Please try again");
    }
  }

  Future login(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthServiceException(
            message: "Username not found - did you mean to signup instead?");
      } else if (e.code == 'wrong-password') {
        throw AuthServiceException(message: "Wrong password");
      }
      throw AuthServiceException(
          message:
              "An unknown authentication error occurred in login! Please try again");
    }
  }

  Future logout() async {
    await firebaseAuth.signOut();
  }
}
