import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:excel/excel.dart' hide Border;
import 'package:path_provider/path_provider.dart';

class BillScreen extends StatelessWidget {
  const BillScreen({super.key});

  Future<String?> saveExcelToDownloads(Excel excel, String fileName) async {
    var status = await Permission.storage.request();
    if (!status.isGranted) return null;

    Directory downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Documents');
    } else {
      downloadsDir = await getApplicationDocumentsDirectory();
    }

    String filePath = '${downloadsDir.path}/$fileName';
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    return filePath; // 🔹 Return saved path
  }

  Future<void> exportOrdersToExcel(List<Map<String, dynamic>> orders) async {
    var excel = Excel.createExcel();
    Sheet sheet = excel['Sheet1'];

    // 🔹 Header row - TextCellValue use karein
    sheet.appendRow([
      TextCellValue('Order ID'),
      TextCellValue('Customer ID'),
      TextCellValue('Customer Name'),
      TextCellValue('Status'),
      TextCellValue('Item Name'),
      TextCellValue('Quantity'),
      TextCellValue('Price'),
      TextCellValue('Total Price'),
      TextCellValue('Delivery Fee'),
      TextCellValue('Service Fee'),
      TextCellValue('Total Amount'),
    ]);

    for (var orderData in orders) {
      final order = orderData['order'] as Map<String, dynamic>;
      final customerId = orderData['customerId'];
      final customerName = orderData['customerName'];
      final items = (order['items'] ?? []) as List<dynamic>;

      for (var item in items) {
        // Har value ko TextCellValue mein wrap karein
        sheet.appendRow([
          TextCellValue(
            orderData['orderId']?.toString() ?? '-',
          ), // Order ID add karein
          TextCellValue(customerId.toString()),
          TextCellValue(customerName),
          TextCellValue(order['status']?.toString() ?? '-'),
          TextCellValue(item['name']?.toString() ?? '-'),
          TextCellValue(item['quantity']?.toString() ?? '-'),
          TextCellValue(item['price']?.toString() ?? '-'),
          TextCellValue(item['totalPrice']?.toString() ?? '-'),
          TextCellValue(order['deliveryFee']?.toString() ?? '0'),
          TextCellValue(order['serviceFee']?.toString() ?? '0'),
          TextCellValue(order['totalAmount']?.toString() ?? '0'),
        ]);
      }
    }

    // 🔹 Save file
    String? filePath = await saveExcelToDownloads(excel, 'Orders.xlsx');
    if (filePath != null) {
      print("Excel file saved at $filePath");
    }
  }

  Future<List<Map<String, dynamic>>> fetchOrdersWithUsers() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    List<Map<String, dynamic>> allOrders = [];

    // 🔹 Get all orders
    QuerySnapshot ordersSnapshot = await firestore.collection('orders').get();

    for (var orderDoc in ordersSnapshot.docs) {
      final orderData = orderDoc.data() as Map<String, dynamic>? ?? {};
      final userUid = orderData['userId']; // userId = uid in your structure

      String customerName = "Unknown";
      int customerId = 0;

      if (userUid != null) {
        final userSnapshot = await firestore
            .collection('users')
            .where('uid', isEqualTo: userUid)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          final userData = userSnapshot.docs.first.data();
          customerName = userData['fullname'] ?? 'Unknown';
          customerId = userData['id'] ?? 0;
        }
      }

      allOrders.add({
        'order': orderData,
        'customerName': customerName,
        'customerId': customerId,
        'orderId': orderDoc.id, // ✅ Yeh line add karein
      });
    }

    return allOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFC4D0C0),
      appBar: AppBar(
        backgroundColor: const Color(0XFFC4D0C0),
        centerTitle: true,
        title: Text(
          "Invoices",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0XFF476C2F),
          ),
        ),
        // AppBar me download button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchOrdersWithUsers(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox(); // loading state

                final orders = snapshot.data!; // ye hi variable use karo

                return Container(
                  decoration: BoxDecoration(
                    color: Color(0XFF476C2F).withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.download_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () async {
                      await exportOrdersToExcel(orders);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Orders exported to Excel!"),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchOrdersWithUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0XFF476C2F)),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final ordersData = snapshot.data ?? [];

          if (ordersData.isEmpty) {
            return const Center(child: Text("No Invoices Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: ordersData.length,
            itemBuilder: (context, index) {
              final orderData = ordersData[index];
              final order = orderData['order'];
              final items = (order['items'] ?? []) as List<dynamic>;

              return _buildOrderCard(
                order,
                items,
                orderData['customerId'],
                orderData['customerName'],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(
    Map<String, dynamic> order,
    List items,
    int customerId,
    String customerName,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 14),
          child: Text(
            order['status'] ?? 'Unknown',
            style: TextStyle(
              color: order['status'] == "Pending"
                  ? Colors.orange
                  : order['status'] == "Completed"
                  ? Colors.green
                  : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0XFF456B2E).withOpacity(0.53),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🧾 Customer Info
              Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Customer ID: ",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0XFF454545),
                        ),
                      ),
                      Text(
                        "$customerId",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0XFF428DFF),
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text(
                        "Customer Name: ",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0XFF454545),
                        ),
                      ),
                      Text(
                        customerName,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: const Color(0XFF428DFF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 70),
                  Text(
                    "Items",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF454545),
                    ),
                  ),
                  SizedBox(width: 100),
                  Text(
                    "Quantity",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF454545),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Total Amount",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF454545),
                    ),
                  ),
                ],
              ),
              // 🟢 Order Items
              Column(
                children: items.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['imageUrl'] ??
                                "https://via.placeholder.com/50",
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: ${item['name'] ?? '-'}",
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: const Color(0XFF9D9999),
                              ),
                            ),
                            Text(
                              "Price: ${item['price'] ?? '-'} OMR",
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: const Color(0XFF9D9999),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          "x ${item['quantity'] ?? '-'}",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF9D9999),
                          ),
                        ),
                        const SizedBox(width: 40),
                        Text(
                          "${item['totalPrice'] ?? '-'} OMR",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0XFF9D9999),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const Divider(thickness: 1, color: Color(0XFF9D9D9D)),

              // 🟢 Order Total & Fees
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Delivery Fee: ${order['deliveryFee'] ?? '0'} OMR\n"
                    "Service Fee: ${order['serviceFee'] ?? '0'} OMR",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF9D9999),
                    ),
                  ),
                  Text(
                    "${(order["totalAmount"] as num).toStringAsFixed(2)} OMR",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
