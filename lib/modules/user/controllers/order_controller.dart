import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference ordersCollection = FirebaseFirestore.instance
      .collection("orders");
  Future<String> placeOrder({
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
      "feedbacks": [],
    };

    // 🔹 Firestore pe order save karna
    final docRef = await _firestore.collection("orders").add(orderData);

    // 🔹 For Automated Testing
    print("🧾 NEW ORDER PLACED -------------------------");
    print("📦 Order ID: ${docRef.id}");
    print("👤 User ID: ${user.uid}");
    print(
      "📍 Address: ${address["street"] ?? "N/A"}, ${address["city"] ?? ""}",
    );
    print("💳 Payment Method: $paymentMethod");
    if (paymentMethod == "Card") {
      print("💳 Card Info: ${cardData ?? {}}");
    }
    print("💰 Subtotal: $subtotal");
    print("🚚 Delivery Fee: $deliveryFee");
    print("🧾 Service Fee: $serviceFee");
    print("💵 Total Amount: $totalAmount");
    print("🛒 Cart Items:");
    for (var item in cartItems) {
      print(
        "  • ${item["name"]} | Qty: ${item["quantity"]} | Price: ${item["price"]} | Total: ${item["totalPrice"]}",
      );
    }
    print("-------------------------------------------");

    // 🔹 Cart clear karna
    final cartRef = _firestore
        .collection("carts")
        .doc(user.uid)
        .collection("items");
    final cartSnapshot = await cartRef.get();
    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }

    return docRef.id; // 🔹 Return karega orderId
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

  //save Feedback
  Future<void> saveFeedback({
    required String orderId,
    required List<Map<String, dynamic>> feedbacks,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    // order document me feedbacks array update kar do
    await _firestore.collection("orders").doc(orderId).update({
      "feedbacks": FieldValue.arrayUnion(feedbacks),
    });
  }

  /// Load previous address from last order
  Future<Map<String, dynamic>?> getPreviousAddress() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final orderSnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (orderSnapshot.docs.isNotEmpty) {
        final lastOrder = orderSnapshot.docs.first.data();
        return lastOrder['address'] != null
            ? Map<String, dynamic>.from(lastOrder['address'])
            : null;
      }
      return null;
    } catch (e) {
      debugPrint("Error fetching address: $e");
      return null;
    }
  }

  // Update status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await ordersCollection.doc(orderId).update({"status": status});
  }
}
