import 'package:cloud_firestore/cloud_firestore.dart';

class UserProductController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get Products Stream (for listing)
  Stream<QuerySnapshot> getProducts() {
    return _firestore.collection("products").snapshots();
  }
}
