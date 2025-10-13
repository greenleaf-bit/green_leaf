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

    // Search ke hisaab se filter karo
    return _firestore
        .collection("products")
        .where("name", isGreaterThanOrEqualTo: search)
        .where("name", isLessThanOrEqualTo: search + '\uf8ff')
        .snapshots();
  }
}
