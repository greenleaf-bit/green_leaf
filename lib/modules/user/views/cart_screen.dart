import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/main_screen.dart';
import 'package:green_leaf/modules/user/controllers/cart_controller.dart';
import 'package:green_leaf/modules/user/views/address_screen.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController cartController = CartController();

  @override
  Widget build(BuildContext context) {
    const deliveryFee = 0.350;
    const serviceFee = 0.050;

    return Scaffold(
      backgroundColor: const Color(0XFFC4D0C0),
      appBar: AppBar(
        backgroundColor: const Color(0XFFC4D0C0),
        elevation: 0,

        automaticallyImplyLeading: false,
        title: Text(
          "My Cart",
          style: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF39571E),
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: cartController.getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading cart"));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartDocs = snapshot.data!.docs;

          double subtotal = 0;
          for (var doc in cartDocs) {
            subtotal += (doc["totalPrice"] ?? 0).toDouble();
          }

          double totalAmount = subtotal + deliveryFee + serviceFee;

          return cartDocs.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartDocs.length,
                        itemBuilder: (context, index) {
                          final data =
                              cartDocs[index].data() as Map<String, dynamic>;
                          final productId = cartDocs[index].id;
                          final quantity = data["quantity"] ?? 1;
                          final price = (data["price"] ?? 0).toDouble();
                          final name = data["name"] ?? "No name";
                          final type = data["type"] ?? "No type";
                          final imageUrl =
                              data["imageUrl"] ??
                              "https://via.placeholder.com/150";

                          return Card(
                            color: Color(0XFFE8F5EE),
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                    onPressed: () {
                                      cartController.deleteFromCart(
                                        productId,
                                        context,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Colors.white,
                                        ),
                                        child: Image.network(
                                          imageUrl,
                                          width: 60,
                                          height: 70,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15,
                                              ),
                                              child: Text(
                                                name,
                                                style: GoogleFonts.inter(
                                                  fontSize: 20,
                                                  color: Color(0XFF476C2F),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 15,
                                              ),
                                              child: Text(
                                                type,
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  color: Color(0XFF9D9999),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,

                                              children: [
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    if (quantity > 1) {
                                                      cartController
                                                          .updateQuantity(
                                                            productId,
                                                            quantity - 1,
                                                            price,
                                                          );
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Color(0XFF3B7254),
                                                  ),
                                                ),
                                                Text(
                                                  "$quantity",
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    color: Color(0XFF3B7254),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    cartController
                                                        .updateQuantity(
                                                          productId,
                                                          quantity + 1,
                                                          price,
                                                        );
                                                  },
                                                  icon: const Icon(
                                                    Icons.add_circle_outline,
                                                    color: Color(0XFF3B7254),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: Color(0XFF476C2F),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          "${(price * quantity).toStringAsFixed(3)} OMR",
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0XFFFFFFFF),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // Payment Summary
                    cartDocs.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "Payment Summary",
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0XFF476C2F),
                                  ),
                                ),
                                summaryRow("Subtotal", subtotal),
                                summaryRow("Delivery Fee", deliveryFee),
                                summaryRow("Service Fee", serviceFee),
                                const Divider(
                                  thickness: 2,
                                  color: Color(0XFF9D9D9D),
                                ),
                                summaryRow(
                                  "Total Amount",
                                  totalAmount,
                                  bold: true,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) =>
                                                  CustomBottomBar(),
                                            ),
                                            (route) => false,
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Color(0XFF456B2E),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Add Items",
                                          style: GoogleFonts.inter(
                                            color: Color(0XFF456B2E),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) {
                                                return AddressScreen(
                                                  subtotal: subtotal,
                                                  deliveryFee: deliveryFee,
                                                  serviceFee: serviceFee,
                                                  cartItems: cartDocs
                                                      .map(
                                                        (doc) =>
                                                            doc.data()
                                                                as Map<
                                                                  String,
                                                                  dynamic
                                                                >,
                                                      )
                                                      .toList(),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0XFF456B2E),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          "Checkout",
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 70),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                )
              : Center(
                  child: Text(
                    "Your cart is empty",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF476C2F),
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget summaryRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0XFF476C2F),
            ),
          ),
          Text(
            "${value.toStringAsFixed(3)} OMR",
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0XFF476C2F),
            ),
          ),
        ],
      ),
    );
  }
}
