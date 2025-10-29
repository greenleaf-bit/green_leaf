import 'package:cloud_firestore/cloud_firestore.dart';

class UserProductController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get Products Stream (for listing)
  Stream<QuerySnapshot> getProducts() {
    return _firestore.collection("products").snapshots();
  }

  Stream<QuerySnapshot> getProductsBySearch({String? search}) {
    if (search == null || search.isEmpty) {
      return _firestore.collection("products").snapshots();
    }

    String searchLower = search.toLowerCase();

    return _firestore
        .collection("products")
        .where("name_lowercase", isGreaterThanOrEqualTo: searchLower)
        .where("name_lowercase", isLessThanOrEqualTo: searchLower + '\uf8ff')
        .snapshots();
  }
}
