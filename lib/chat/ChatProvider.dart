import 'ChatMessage.dart';

class ChatProvider {

  Future<void> updateFirestoreData(String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore
      .collection(collectionPath)
      .doc(docPath)
      .update(dataUpdate);
  }

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    return firebaseFirestore
      .collection(FirestoreConstants.pathMessageCollection)
      .doc(groupChatId)
      .collection(groupChatId)
      .orderBy(FirestoreConstants.timestamp, descending: true)
      .limit(limit)
      .snapshots();
  }

  void sendChatMessage(String content, int type, String groupChatId, String currentUserId, String peerId) {
    DocumentReference documentReference = firebaseFirestore
      .collection(FirestoreConstants.pathMessageCollection)
      .doc(groupChatId)
      .collection(groupChatId)
      .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessage chatMessages = ChatMessage(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson());
    });
  }

}