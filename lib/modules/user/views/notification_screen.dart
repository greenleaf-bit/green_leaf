import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/controllers/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  String _getStatusMessage(String status) {
    switch (status) {
      case "Pending":
        return "Order Placed";
      case "Order Cancelled":
        return "Order Cancelled";
      case "Order Delivered":
        return "Order Delivered";
      default:
        return "Order Updated";
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Cancelled":
        return Colors.red;
      case "Completed":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = NotificationController();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Notifications",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0XFF476C2F),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0XFF476C2F),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
      ),

      // 🔥 StreamBuilder connects with NotificationController
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getUserNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return Center(
              child: Text(
                "No notifications yet",
                style: GoogleFonts.inter(fontSize: 15, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final status = data["status"] ?? "Unknown";
              final items = (data["items"] ?? []) as List<dynamic>;
              final docId = docs[index].id;

              return GestureDetector(
                onTap: () => controller.markAsRead(docId),
                child: Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    title: Text(
                      _getStatusMessage(status),
                      style: GoogleFonts.inter(
                        color: _getStatusColor(status),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "Order ID: ${data["orderId"] ?? "N/A"}",
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                    children: [
                      const Divider(),
                      ...items.map((item) {
                        return ListTile(
                          dense: true,
                          title: Text(
                            item["name"] ?? "Unnamed Product",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            "Qty: ${item["quantity"]} | Total: ${item["totalPrice"]}",
                            style: GoogleFonts.inter(fontSize: 13),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
