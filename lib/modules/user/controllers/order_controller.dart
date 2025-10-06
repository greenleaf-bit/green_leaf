import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> placeOrder({
    required Map<String, String> address,
    required String paymentMethod,
    Map<String, String>? cardData,
    required double subtotal,
    required double deliveryFee,
    required double serviceFee,
    required double totalAmount,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    final user = _auth.currentUser;

    if (user == null) throw Exception("User not logged in");

    final orderData = {
      "localCreatedAt": DateTime.now(),

      "userId": user.uid,
      "createdAt": FieldValue.serverTimestamp(),
      "address": address,
      "paymentMethod": paymentMethod,
      "cardData": cardData ?? {},
      "subtotal": subtotal,
      "deliveryFee": deliveryFee,
      "serviceFee": serviceFee,
      "totalAmount": totalAmount,
      "items": cartItems,
      "status": "Pending",
    };

    await _firestore.collection("orders").add(orderData);

    // Optionally clear cart after placing order
    final cartRef = _firestore
        .collection("carts")
        .doc(user.uid)
        .collection("items");
    final cartSnapshot = await cartRef.get();
    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  //get order by user id
  Stream<QuerySnapshot> getUserOrders() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception("User not logged in");
    }

    return _firestore
        .collection("orders")
        .where("userId", isEqualTo: user.uid)
        .orderBy("localCreatedAt", descending: true)
        .snapshots();
  }
}
