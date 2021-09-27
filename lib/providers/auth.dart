import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException({required this.message});
}

// Ideally this should be a Singleton injected using DI
class Authentication {
  final firebaseAuth = FirebaseAuth.instance;

  User? currentUser() {
    return firebaseAuth.currentUser;
  }

  void signup(String email, String password) async {
    try {
      firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch(e) {
      if (e.code == 'weak-password') {
        throw AuthenticationException(message: "Password is weak");
      } else if (e.code == 'email-already-in-use') {
        throw AuthenticationException(message: "Email is already in use - did you mean to login instead?");
      }
      throw AuthenticationException(message: "An unknown authentication error occurred in signup! Please try again");
    }
  }

  void login(String email, String password) async {
    try {
      firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch(e) {
      if (e.code == 'user-not-found') {
        throw AuthenticationException(message: "Username not found - did you mean to signup instead?");
      } else if (e.code == 'wrong-password') {
        throw AuthenticationException(message: "Wrong password - don't use hunter2");
      }
      throw AuthenticationException(message: "An unknown authentication error occurred in login! Please try again");
    }
  }
}