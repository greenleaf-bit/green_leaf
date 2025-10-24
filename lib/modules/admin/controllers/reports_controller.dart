import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportsController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Fetch total orders count
  Future<int> getTotalOrdersCount(BuildContext context) async {
    try {
      QuerySnapshot ordersSnapshot = await _firestore.collection("orders").get();
      return ordersSnapshot.docs.length;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching order count: $e")),
      );
      return 0;
    }
  }

  /// 🔹 Fetch total revenue (sum of totalAmount field)
  Future<double> getTotalRevenue(BuildContext context) async {
    try {
      QuerySnapshot ordersSnapshot = await _firestore.collection("orders").get();
      double totalRevenue = 0.0;

      for (var doc in ordersSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data["totalAmount"] != null) {
          totalRevenue += double.tryParse(data["totalAmount"].toString()) ?? 0.0;
        }
      }

      return totalRevenue;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching total revenue: $e")),
      );
      return 0.0;
    }
  }

  /// 🔹 Fetch total feedbacks count from all orders
  Future<int> getTotalFeedbacksCount(BuildContext context) async {
    try {
      QuerySnapshot ordersSnapshot = await _firestore.collection("orders").get();
      int totalFeedbacks = 0;

      for (var doc in ordersSnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;

        // Agar 'feedbacks' ek list hai to uska length count karo
        if (data["feedbacks"] != null && data["feedbacks"] is List) {
          totalFeedbacks += (data["feedbacks"] as List).length;
        }
      }

      return totalFeedbacks;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching feedback count: $e")),
      );
      return 0;
    }
  }
}
