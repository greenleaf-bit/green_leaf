import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrderController {
  final CollectionReference ordersCollection = FirebaseFirestore.instance
      .collection("orders");

  // Get all orders
  Stream<QuerySnapshot> getAllOrders() {
    return ordersCollection.orderBy("createdAt", descending: true).snapshots();
  }

  // Update status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await ordersCollection.doc(orderId).update({"status": status});
  }
}
