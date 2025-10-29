import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<QuerySnapshot> getUserNotifications() {
    final user = _auth.currentUser;
    if (user == null) {
      // Agar user login nahi hai to empty stream return karo
      return const Stream.empty();
    }

    return _firestore
        .collection("notifications")
        .where("userId", isEqualTo: user.uid)
        .where("isRead", isEqualTo: false)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // Update notification status (read/unread)
  Future<void> markAsRead(String docId) async {
    await _firestore.collection("notifications").doc(docId).update({
      "isRead": true,
    });
  }

  // 📦 Add notification when order status changes
  Future<void> addNotification({
    required String userId,
    required String orderId,
    required List<Map<String, dynamic>> items,
    required String status,
  }) async {
    await _firestore.collection("notifications").add({
      "userId": userId,
      "orderId": orderId,
      "items": items,
      "status": status,
      "isRead": false,
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
}
