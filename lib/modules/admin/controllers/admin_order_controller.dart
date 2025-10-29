import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference ordersCollection = FirebaseFirestore.instance
      .collection("orders");

  // Get all orders
  Stream<QuerySnapshot> getAllOrders() {
    return ordersCollection.orderBy("createdAt", descending: true).snapshots();
  }

  // Update status + Notification logic
  Future<void> updateOrderStatus(String orderId, String status) async {
    await ordersCollection.doc(orderId).update({"status": status});

    //  Get the full order data (to get userId and items)
    final orderDoc = await ordersCollection.doc(orderId).get();
    if (!orderDoc.exists) return;

    final orderData = orderDoc.data() as Map<String, dynamic>;
    final String userId = orderData["userId"];
    final List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(
      orderData["items"],
    );

    //  Mark old notifications for this order as read
    final notificationQuery = await _firestore
        .collection("notifications")
        .where("orderId", isEqualTo: orderId)
        .where("userId", isEqualTo: userId)
        .get();

    for (var doc in notificationQuery.docs) {
      await doc.reference.update({"isRead": true});
    }

    //  Add new notification for user based on updated status
    String messageStatus = "";
    if (status == "Cancelled") {
      messageStatus = "Order Cancelled";
    } else if (status == "Completed") {
      messageStatus = "Order Delivered";
    } else if (status == "Pending") {
      messageStatus = "Order Placed";
    }

    await _firestore.collection("notifications").add({
      "userId": userId,
      "orderId": orderId,
      "items": items,
      "status": messageStatus,
      "isRead": false,
      "createdAt": FieldValue.serverTimestamp(),
    });

    print("✅ Admin updated order to $status and notification sent to $userId");
  }
}
