import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/admin_order_controller.dart';

class ManageOrderScreen extends StatelessWidget {
  final AdminOrderController adminOrderController = AdminOrderController();

  ManageOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Manage Orders",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0XFF476C2F),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: adminOrderController.getAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders found"));
          }

          final orders = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final orderDoc = orders[index];
                final order = orderDoc.data() as Map<String, dynamic>;

                final createdAt = (order["createdAt"] as Timestamp?)?.toDate();
                final formattedDate = createdAt != null
                    ? DateFormat("dd/MM/yyyy  hh:mma").format(createdAt)
                    : "Unknown Date";

                final items = List<Map<String, dynamic>>.from(order["items"]);
                final status = order["status"] ?? "Pending";

                return Column(
                  children: [
                    // Date + Status row
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                        top: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            formattedDate,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          Text(
                            status,
                            style: TextStyle(
                              color: status == "Pending"
                                  ? Colors.orange
                                  : status == "Completed"
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Order container
                    Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0XFF3B6C1E).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0XFF3B6C1E)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            children: [
                              const SizedBox(width: 60),
                              Text(
                                "Item",
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: const Color(0xFF454545),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 110),
                              Text(
                                "Quantity",
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: const Color(0xFF454545),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 30),
                              Text(
                                "Total Amount",
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: const Color(0xFF454545),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          // Items
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: items.map((item) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        item["imageUrl"] ?? "",
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Name: ${item["name"] ?? ""}",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: const Color(0xFF9D9999),
                                          ),
                                        ),
                                        Text(
                                          "Price: ${item["price"]} OMR",
                                          style: GoogleFonts.inter(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: const Color(0xFF9D9999),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      "x${item["quantity"]}",
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: const Color(0xFF9D9999),
                                      ),
                                    ),
                                    const SizedBox(width: 60),
                                    Expanded(
                                      child: Text(
                                        "${item["totalPrice"]} OMR",
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: const Color(0xFF9D9999),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),

                          const Divider(thickness: 1, color: Color(0XFF9D9D9D)),

                          // Total + Fees
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Delivery Fee: ${order["deliveryFee"]} OMR\nService Fee: ${order["serviceFee"]} OMR",
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                  color: const Color(0xFF9D9999),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "${order["totalAmount"].toStringAsFixed(3)} OMR",
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          // ✅ Cancel / Proceed buttons row
                          if (status == "Pending")
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await adminOrderController
                                        .updateOrderStatus(
                                          orderDoc.id,
                                          "Cancelled",
                                        );
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () async {
                                    await adminOrderController
                                        .updateOrderStatus(
                                          orderDoc.id,
                                          "Completed",
                                        );
                                  },
                                  child: const Text("Proceed"),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
