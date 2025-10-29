import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference ordersCollection = FirebaseFirestore.instance
      .collection("orders");
  final CollectionReference notificationsCollection = FirebaseFirestore.instance
      .collection("notifications");

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

    // 🔹 Save Order to Firestore
    final docRef = await ordersCollection.add(orderData);

    // 🔹 Save Notification for this order
    await notificationsCollection.add({
      "userId": user.uid,
      "items": cartItems,
      "orderId": docRef.id,
      "status": "Pending",
      "createdAt": FieldValue.serverTimestamp(),
      "isRead": false,
      "localCreatedAt": DateTime.now(),
    });

    // 🔹 Debug log
    print("🧾 NEW ORDER PLACED -------------------------");
    print("📦 Order ID: ${docRef.id}");
    print("👤 User ID: ${user.uid}");
    print("💰 Total Amount: $totalAmount");
    print("-------------------------------------------");

    // 🔹 Clear user's cart
    final cartRef = _firestore
        .collection("carts")
        .doc(user.uid)
        .collection("items");
    final cartSnapshot = await cartRef.get();
    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }

    return docRef.id; // Return orderId
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

    // 🔹 har feedback me userId inject kar do
    final feedbacksWithUser = feedbacks.map((f) {
      return {
        ...f,
        "userId": user.uid,
        "createdAt": Timestamp.now(), // <-- use Timestamp.now()
      };
    }).toList();

    // 🔹 Firestore me update karo
    await _firestore.collection("orders").doc(orderId).update({
      "feedbacks": FieldValue.arrayUnion(feedbacksWithUser),
    });

    print("✅ Feedbacks saved with userId for ${user.uid}");
  }

  /// Check if a feedback for a specific product already exists
  /// ✅ Check if current user has already given feedback for this product
  Future<bool> hasFeedbackForProduct(String orderId, String productId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return false;

      // Get order document
      final orderDoc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();

      if (!orderDoc.exists) return false;

      final data = orderDoc.data();
      if (data == null || data['feedbacks'] == null) return false;

      List feedbacks = data['feedbacks'];

      // ✅ Condition: if any feedback in array has both same userId and same productId
      final alreadyGiven = feedbacks.any(
        (f) =>
            f['userId'] != null &&
            f['productId'] != null &&
            f['userId'] == user.uid &&
            f['productId'] == productId,
      );

      if (alreadyGiven) {
        print(
          "🚫 User ${user.uid} already gave feedback for product $productId",
        );
      } else {
        print("✅ User ${user.uid} can give feedback for product $productId");
      }

      return alreadyGiven;
    } catch (e) {
      print("❌ Error checking feedback existence: $e");
      return false;
    }
  }

  Future<List<String>> getFeedbackGivenProductIds(String orderId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return [];

      print("🔍 Fetching feedbacks for order: $orderId");

      final orderDoc = await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .get();

      if (orderDoc.exists && orderDoc.data()?['feedbacks'] != null) {
        final feedbacks = List<Map<String, dynamic>>.from(
          orderDoc.data()?['feedbacks'],
        );

        //  Sirf current user ke diye hue feedback filter karo
        final userFeedbacks = feedbacks
            .where((f) => f['userId'] == user.uid)
            .toList();

        print("✅ Found ${userFeedbacks.length} feedback(s) by ${user.uid}");
        for (var fb in userFeedbacks) {
          print("📦 Feedback productId: ${fb['productId']}");
        }

        // Ab sirf unhi productId return karo jinke liye current user ne feedback diya ho
        return userFeedbacks.map((f) => f['productId'].toString()).toList();
      }

      print("⚠️ No feedbacks found for this order");
      return [];
    } catch (e) {
      print("❌ Error getting feedback given products: $e");
      return [];
    }
  }

  Future<void> saveUserAddress(Map<String, String> address) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print("❌ No logged in user found");
        return;
      }

      await _firestore.collection("users").doc(user.uid).set(
        {"address": address},
        SetOptions(merge: true), // merge = update existing data, not overwrite
      );

      print("✅ Address saved successfully for ${user.uid}");
    } catch (e) {
      print("❌ Error saving address: $e");
    }
  }

  /// Load previous address from last order
  Future<Map<String, dynamic>?> getPreviousAddress() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        if (data.containsKey('address') && data['address'] != null) {
          return Map<String, dynamic>.from(data['address']);
        }
      }

      return null;
    } catch (e) {
      debugPrint("❌ Error fetching address: $e");
      return null;
    }
  }

  Future<void> updateAddress(Map<String, dynamic> address) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('users').doc(user.uid).update({
        'address': address,
      });
    } catch (e) {
      debugPrint("❌ Error updating address: $e");
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    // 🔹 1. Update order status in Firestore
    await ordersCollection.doc(orderId).update({"status": status});

    // 🔹 2. Mark related notifications as read
    final notificationQuery = await FirebaseFirestore.instance
        .collection("notifications")
        .where("orderId", isEqualTo: orderId)
        .where("userId", isEqualTo: user.uid)
        .get();

    for (var doc in notificationQuery.docs) {
      await doc.reference.update({"isRead": true});
    }

    // Add new notification (Order Cancelled / Delivered etc.)
    String messageStatus = "";
    if (status == "Cancelled") {
      messageStatus = "Order Cancelled";
    } else if (status == "Delivered") {
      messageStatus = "Order Delivered";
    } else if (status == "Pending") {
      messageStatus = "Order Placed";
    }

    // fetch old order items to show in notification
    final orderSnap = await ordersCollection.doc(orderId).get();
    final items = List<Map<String, dynamic>>.from(orderSnap["items"]);

    await FirebaseFirestore.instance.collection("notifications").add({
      "userId": user.uid,
      "orderId": orderId,
      "items": items,
      "status": messageStatus,
      "isRead": false,
      "createdAt": FieldValue.serverTimestamp(),
    });

    print("✅ Order updated to $status and notification added.");
  }
}
