import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider {

  static late FirebaseAuth _auth;
  late FirebaseFirestore firebaseFirestore;

  static void initAuth() async {
    _auth = await FirebaseAuth.instance;
  }

  static  Future<bool> createAccount(email, password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (err) {
      print(err.code);
      print(err.message);
    }
    return isLoggedIn();
  }

  static  Future<bool> singIn(email, password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (err) {
      print(err.code);
      print(err.message);
    }
    return isLoggedIn();
  }

  static Future<void> singOut() async {
      await _auth.signOut();
  }

  static bool isLoggedIn() {
    User? user = _auth.currentUser;

    if(user != null) return true;

    return false;
  }

}