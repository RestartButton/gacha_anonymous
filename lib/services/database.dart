import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth.dart';

class DatabaseMethods{

  static late FirebaseFirestore _db;
  static FirebaseFirestore get db => _db;

  static initDatabase() {

    _db = FirebaseFirestore.instance;

  }

  static Future updateUser(String? userId, Map<String,dynamic> user) async {

    try{
      await _db.collection("users").doc(userId).set(user);
    } catch (err) {
      print("Erro: $err");
    }

  }


  static Future getUserInfo() async {

    try{
      if(AuthService.isLoggedIn()){
        Map<String,dynamic>? user;
        await _db.collection("users").doc(AuthService.auth.currentUser?.uid).get().then(
          (value) => user = value.data()
        );
        return user;
      }
    } catch (err) {
      print("Erro: $err");
    }

  }

  static Future sendMessage(String? idChat, Map<String, dynamic> message) async {

    await _db.collection("chats").doc(idChat).collection("messages").add({
      "content": message["content"],
      "id_receiver": message["id_receiver"],
      "id_sender": message["id_sender"],
      "sent_time": Timestamp.fromDate(DateTime.now()),
    });

  }

  static Future addContact(String idContact) async {

    await _db.collection("contacts").add({
      "id_user": AuthService.auth.currentUser?.uid,
      "id_contact": idContact,
    });
    await _db.collection("contacts").add({
      "id_contact": AuthService.auth.currentUser?.uid,
      "id_user": idContact,
    });

    _createChatRoom(idContact);

  }

  static Future _createChatRoom(String idContact) async {

    String? chatId;
    await _db.collection("chats").add({}).then(
      (value) => chatId = value.id
    );

    await _db.collection("users").doc(AuthService.auth.currentUser?.uid).collection("chats").add({
      "id": chatId,
      "id_contact": idContact,
    });

    await _db.collection("users").doc(idContact).collection("chats").add({
      "id": chatId,
      "id_contact": AuthService.auth.currentUser?.uid,
    });

  }

  static Future createPost(String content, String idUser) async {

    await _db.collection("posts").add({
      "content": content,
      "id_creator": idUser,
      "post_time": Timestamp.fromDate(DateTime.now()),
    });

  }

  static Future updatePost(String idPost, String newContent) async {

    await _db.collection("posts").doc(idPost).update({
      "content": newContent,
    });
  
  }

  static Future deletePost(String idPost) async {

    await _db.collection("posts").doc(idPost).delete();

  }

  static Future deleteUser() async {

    await _db.collection("users").doc(AuthService.auth.currentUser?.uid).delete();
    await AuthService.deleteUser();

  }

  static Future deleteContact(String idContact) async {
    
    var contactsSnapshot = await _db.collection("contacts").where("id_user", isEqualTo: AuthService.auth.currentUser?.uid).get();
    for(var contactDocumentSnapshot in contactsSnapshot.docs) {
        var contact = contactDocumentSnapshot.data();
        if(contact["id_contact"] == idContact) {
          await _db.collection("contacts").doc(contactDocumentSnapshot.id).delete();
        }
    }
    
  }

}