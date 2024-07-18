import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? _user;

  AuthServices() {
    _firebaseAuth.authStateChanges().listen(userChangesStreamListener);
  }

  User? get user {
    return _user;
  }

  Future<void>? userChangesStreamListener(User? user) {
    if (user != null) {
      _user = user;
    } else {
      _user = null;
    }
    return null;
  }

  Future<bool> logIn({String? email, String? password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email!, password: password!);
      if (userCredential.user != null) {
        _user = userCredential.user;
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> signUp({String? email, String? password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      if(userCredential.user!=null){
        _user = userCredential.user!;
        return true;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }

  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      debugPrint(e.toString());
    }
    return false;
  }
}
