import 'package:cloud_firestore/cloud_firestore.dart';
import './model.dart' as model;

class DatabaseHelper {
  final CollectionReference collection = 
   FirebaseFirestore.instance.collection(model.Transaction.collectionName);

  //insert transaction
  Future<DocumentReference> insertProduct(model.Transaction transaction) {
    return collection.add(transaction.toJson());
  }

  //update transaction
  // void updateTransaction(model.Transaction transaction) async {
  //   await collection.doc(transaction.referenceId).update(transaction.toJson());
  // }

  // //delete transaction
  // void deleteTransaction(model.Transaction transaction) async {
  //   await collection.doc(transaction.referenceId).delete();
  // }

  //get all documents from collection
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<QuerySnapshot> searchTransaction(String keyValue) {
    return collection.where(model.Transaction.collectionName, isEqualTo: keyValue).get();
  }
}