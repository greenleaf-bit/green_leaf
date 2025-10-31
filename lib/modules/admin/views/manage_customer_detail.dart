import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/admin/controllers/customer_controller.dart';
import 'package:green_leaf/modules/admin/views/admin_bottom_bar.dart';
import 'package:green_leaf/modules/admin/views/admin_home_screen.dart';

class ManageCustomerDetail extends StatefulWidget {
  final Map<String, dynamic> userData;
  const ManageCustomerDetail({super.key, required this.userData});

  @override
  State<ManageCustomerDetail> createState() => _ManageCustomerDetailState();
}

class _ManageCustomerDetailState extends State<ManageCustomerDetail> {
  final CustomerController _controller = CustomerController();

  Map<String, dynamic>? address;
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    final fetchedAddress = await _controller.fetchCustomerAddress(
      widget.userData['uid'],
    );
    final fetchedOrders = await _controller.fetchCustomerOrders(
      widget.userData['uid'],
    );

    setState(() {
      address = fetchedAddress;
      orders = fetchedOrders;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.userData;

    return Scaffold(
      backgroundColor: const Color(0XFFC4D0C0),
      appBar: AppBar(
        backgroundColor: const Color(0XFFC4D0C0),
        centerTitle: true,
        title: Text(
          "Manage Customers",
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          Text(
                            "CustomerID",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            "Name",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 30),
                          Text(
                            "Email",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 110),
                          Text(
                            "Phone",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildCustomerHeader(user),

                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        "Address",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // 🔹 Address Box
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0XFF456B2E).withOpacity(0.53),
                        ),
                      ),
                      child: address == null
                          ? const Text("No address found")
                          : Text(
                              "Area: ${address!['area']}, Street: ${address!['street']}, House: ${address!['house']}, Way: ${address!['way']}, Phone: ${address!['phone']}",
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: const Color(0XFF9D9999),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),

                    const Divider(thickness: 1, color: Color(0XFF9D9D9D)),
                    const SizedBox(height: 10),

                    Padding(
                      padding: const EdgeInsets.only(left: 8, right: 8),
                      child: Text(
                        "Orders",
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔹 Orders List
                    orders.isEmpty
                        ? const Text("No orders found")
                        : Column(
                            children: orders.map((order) {
                              final List items =
                                  (order['items'] ?? []) as List<dynamic>;
                              return _buildOrderCard(order, items);
                            }).toList(),
                          ),

                    const SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFFC30808),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () async {
                            // Show confirmation dialog
                            final confirm = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Confirm Delete"),
                                content: const Text(
                                  "Are you sure you want to remove this customer?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                await _controller.deleteCustomer(
                                  widget.userData['uid'],
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Customer deleted successfully",
                                    ),
                                  ),
                                );
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminBottomBar(),
                                  ),
                                  (route) =>
                                      false, // remove all previous routes
                                ); // Go back after deletion
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Error deleting customer: $e",
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            "Remove Customer",
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // 🔹 Customer Header UI
  Widget _buildCustomerHeader(Map<String, dynamic> user) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0XFFE8F5EE),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0XFF3B6C1E).withOpacity(0.6)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 15),

          Text(
            "${user['id'] ?? '-'}",
            style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(width: 52),
          Text(
            "${user['fullname'] ?? '-'}",
            style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(width: 25),
          Text(
            "${user['email'] ?? '-'}",
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
          ),
          const SizedBox(width: 35),
          Text(
            "${user['phone'] ?? 'null'}",
            style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 🔹 Order Card UI
  Widget _buildOrderCard(Map<String, dynamic> order, List items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0XFF456B2E).withOpacity(0.53)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
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
                        item['imageUrl'] ?? "https://via.placeholder.com/50",
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
                            color: Color(0XFF9D9999),
                          ),
                        ),
                        Text(
                          "Price: ${item['price'] ?? '-'} OMR",
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0XFF9D9999),
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
                        color: Color(0XFF9D9999),
                      ),
                    ),
                    const SizedBox(width: 40),
                    Text(
                      "${item['totalPrice'] ?? '-'} OMR",
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0XFF9D9999),
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

          const Divider(thickness: 1, color: Color(0XFF9D9D9D)),

          // 🟢 Feedback Section
          Text(
            "Feedback",
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500),
          ),

          // Agar har product ke liye feedbacks diye hue hain
          if (order['feedbacks'] != null && order['feedbacks'] is List)
            Column(
              children: (order['feedbacks'] as List).map((feedback) {
                final desc = feedback['description'] ?? '-';
                final rating = (feedback['rating'] ?? 0).toInt();

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description: $desc",
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0XFF9D9999),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "Rating: ",
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0XFF9D9999),
                            ),
                          ),
                          // 🟢 Show stars based on rating
                          Row(
                            children: List.generate(
                              rating,
                              (index) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                "No Feedbacks Yet",
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF9D9999),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
