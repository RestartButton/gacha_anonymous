class ContactsProvider{

  Future<void> updateFirestoreData(
    String collectionPath, String path, Map<String, dynamic> updateData) {
  return firebaseFirestore
      .collection(collectionPath)
      .doc(path)
      .update(updateData);
  }

  Stream<QuerySnapshot> getFirestoreData(
   String collectionPath, int limit, String? textSearch) {
 if (textSearch?.isNotEmpty == true) {
   return firebaseFirestore
       .collection(collectionPath)
       .limit(limit)
       .where(FirestoreConstants.displayName, isEqualTo: textSearch)
       .snapshots();
 } else {
   return firebaseFirestore
       .collection(collectionPath)
       .limit(limit)
       .snapshots();
 }
}

}

