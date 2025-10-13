import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_leaf/modules/user/controllers/order_controller.dart';
import 'package:green_leaf/modules/user/views/address_screen.dart';
import 'package:green_leaf/modules/user/views/card_details.dart';
import 'package:green_leaf/modules/user/views/feedback_screen.dart';
import 'package:green_leaf/modules/user/views/map_widget.dart';
import 'package:green_leaf/modules/user/views/order_screen.dart';
import 'package:green_leaf/modules/user/views/payment_option.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, String> address;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;
  final List<Map<String, dynamic>> cartItems;

  const PaymentScreen({
    super.key,
    required this.address,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
    required this.cartItems,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentMethod = "";
  Map<String, String>? cardData;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final totalAmount =
        widget.subtotal + widget.deliveryFee + widget.serviceFee;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        centerTitle: true,
        title: Text(
          "Payment Method",
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
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 20, bottom: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text(
                "Please select a Location",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF3F6B22),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0XFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Color(0xFF456B2E).withOpacity(0.53),
                  ),
                ),
                child: MapBoxMapWidget(),
              ),
              // Address
              const SizedBox(height: 20),
              Text(
                "Delivery Address",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF3F6B22),
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Color(0xFF456B2E).withOpacity(0.53),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${widget.address['house']}, ${widget.address['street']}, "
                  "Way: ${widget.address['way']}, Area: ${widget.address['area']}, "
                  "Phone: ${widget.address['phone']}",
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Change Address",
                    style: GoogleFonts.inter(
                      color: Color(0XFF456B2E),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              Text(
                "Pay With",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0XFF3F6B22),
                ),
              ),

              const SizedBox(height: 10),
              PaymentOption(
                value: "Card Payment",
                groupValue: paymentMethod,
                text: cardData == null
                    ? "Add Card Data"
                    : cardData!["number"] ?? "",
                iconPath: "assets/icons/visa_icon.png",
                onChanged: (val) async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CardDetails()),
                  );
                  if (result != null) {
                    setState(() {
                      paymentMethod = "Card Payment";
                      cardData = Map<String, String>.from(result);
                    });
                  }
                },
              ),

              const SizedBox(height: 10),
              PaymentOption(
                value: "Cash on Delivery",
                groupValue: paymentMethod,
                text: "Cash On Delivery",
                iconPath: "assets/icons/deliver_icon.png",
                onChanged: (val) {
                  setState(() => paymentMethod = val!);
                },
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Summary",
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0XFF476C2F),
                      ),
                    ),
                    const SizedBox(height: 10),
                    summaryRow("Subtotal", widget.subtotal),
                    summaryRow("Delivery Fee", widget.deliveryFee),
                    summaryRow("Service Fee", widget.serviceFee),
                    const Divider(thickness: 1, color: Color(0XFF9D9D9D)),
                    summaryRow("Total Amount", totalAmount, bold: true),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        if (paymentMethod.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select a payment method"),
                            ),
                          );
                          return;
                        }

                        try {
                          final orderController = OrderController();
                          setState(() {
                            isLoading = true;
                          });
                          final orderId = await orderController.placeOrder(
                            address: widget.address,
                            paymentMethod: paymentMethod,
                            cardData: cardData,
                            subtotal: widget.subtotal,
                            deliveryFee: widget.deliveryFee,
                            serviceFee: widget.serviceFee,
                            totalAmount:
                                widget.subtotal +
                                widget.deliveryFee +
                                widget.serviceFee,
                            cartItems: widget.cartItems,
                          );
                          setState(() {
                            isLoading = false;
                          });

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Color(0XFF5C8B40),
                                        size: 60,
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        "Order Successfully Placed!",
                                        style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0XFF476C2F),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Your payment was successfully!\nJust wait GreenLeaf arrive at\n home asap..",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0XFF476C2F,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 30,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FeedBackScreen(
                                                    orderId: orderId,
                                                    cartItems: widget.cartItems,
                                                  ),
                                            ),
                                            (route) => false,
                                          );
                                        },
                                        child: Text(
                                          "Give Feedback",
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderScreen(),
                                            ),
                                            (route) => false,
                                          );
                                        },
                                        child: Text(
                                          "Go to Orders",
                                          style: GoogleFonts.inter(
                                            color: const Color(0XFF476C2F),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Error: $e")));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF456B2E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Center(
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                "Proceed",
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: const Color(0XFF476C2F),
            ),
          ),
          Text(
            "${value.toStringAsFixed(3)} OMR",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 15,
              color: const Color(0XFF476C2F),
            ),
          ),
        ],
      ),
    );
  }
}
