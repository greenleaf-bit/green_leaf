import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Get All Non-Admin Users List (with phone if available)
  Future<List<Map<String, dynamic>>> getAllUsers(BuildContext context) async {
    List<Map<String, dynamic>> allUsers = [];

    try {
      // Get all users from Firestore
      QuerySnapshot usersSnap = await _firestore.collection("users").get();

      for (var userDoc in usersSnap.docs) {
        final userData = userDoc.data() as Map<String, dynamic>;
        String uid = userDoc.id;

        // 🧠 Skip admin users
        if (userData["role"] != null && userData["role"] == "admin") {
          continue;
        }

        String? phone;

        // 🔹 Get user phone from orders collection
        QuerySnapshot orderSnap = await _firestore
            .collection("orders")
            .where("userId", isEqualTo: uid)
            .limit(1)
            .get();

        if (orderSnap.docs.isNotEmpty) {
          var orderData = orderSnap.docs.first.data() as Map<String, dynamic>;
          if (orderData.containsKey("address") &&
              orderData["address"] != null &&
              orderData["address"]["phone"] != null) {
            phone = orderData["address"]["phone"].toString();
            phone = orderData["address"]["phone"].toString();
          }
        }

        allUsers.add({
          "id": userData["id"],
          "fullname": userData["fullname"],
          "email": userData["email"],
          "phone": phone ?? "null",
          "uid": uid,
        });
      }

      return allUsers;
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error fetching users: $e")));
      return [];
    }
  }

  // 🔹 Fetch Address by User ID
  Future<Map<String, dynamic>?> fetchCustomerAddress(String userId) async {
    try {
      final ordersSnapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();

      if (ordersSnapshot.docs.isNotEmpty) {
        final address = ordersSnapshot.docs.first.data()['address'];
        return {
          'area': address?['area'] ?? '-',
          'street': address?['street'] ?? '-',
          'house': address?['house'] ?? '-',
          'way': address?['way'] ?? '-',
          'phone': address?['phone'] ?? 'null',
        };
      }
      return null;
    } catch (e) {
      print("❌ Error fetching address: $e");
      return null;
    }
  }

  // 🔹 Fetch Orders by User ID
  Future<List<Map<String, dynamic>>> fetchCustomerOrders(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("❌ Error fetching orders: $e");
      return [];
    }
  }

  // Delete customer by UID
  Future<void> deleteCustomer(String uid) async {
    try {
      // Delete from users collection
      await _firestore.collection('users').doc(uid).delete();

      // Optionally delete all orders of that customer
      // final ordersSnapshot = await _firestore
      //     .collection('orders')
      //     .where('userId', isEqualTo: uid)
      //     .get();

      // for (var doc in ordersSnapshot.docs) {
      //   await doc.reference.delete();
      // }

      print("✅ Customer deleted successfully");
    } catch (e) {
      print("❌ Error deleting customer: $e");
      rethrow;
    }
  }
}
