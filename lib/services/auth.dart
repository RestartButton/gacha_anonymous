import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  static late FirebaseAuth _auth;
  static FirebaseAuth get auth => _auth;

  static void initAuth() {
    _auth = FirebaseAuth.instance;
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

  static Future deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      await user.delete();
    }
      
  }

}