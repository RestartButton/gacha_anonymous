import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {

  late FirebaseAuth auth;
  late FirebaseFirestore firebaseFirestore;
  


  Future<bool> createAccount(email, password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password);
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (err) {
      print(err.code);
      print(err.message);
    }
    return isLoggedIn();
  }

  Future<bool> singIn(email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (err) {
      print(err.code);
      print(err.message);
    }
    return isLoggedIn();
  }

  Future<void> singOut() async {
      await auth.signOut();
  }

  bool isLoggedIn() {
    User? user = auth.currentUser;

    if(user != null) return true;

    return false;
  }

}