import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentScreen extends StatefulWidget {
  final Map<String, String> address;
  final double subtotal;
  final double deliveryFee;
  final double serviceFee;

  const PaymentScreen({
    super.key,
    required this.address,
    required this.subtotal,
    required this.deliveryFee,
    required this.serviceFee,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String paymentMethod = "Cash on Delivery";

  @override
  Widget build(BuildContext context) {
    final totalAmount =
        widget.subtotal + widget.deliveryFee + widget.serviceFee;

    return Scaffold(
      backgroundColor: const Color(0XFFC4D0C0),
      appBar: AppBar(
        backgroundColor: const Color(0XFFC4D0C0),
        title: const Text("Payment Method"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address
            Text(
              "Delivery Address",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "${widget.address['house']}, ${widget.address['street']}, "
                "Way: ${widget.address['way']}, Area: ${widget.address['area']}, "
                "Phone: ${widget.address['phone']}",
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 20),

            // Payment Options
            Text(
              "Select Payment Method",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            RadioListTile(
              title: const Text("Cash on Delivery"),
              value: "Cash on Delivery",
              groupValue: paymentMethod,
              onChanged: (val) {
                setState(() => paymentMethod = val!);
              },
            ),
            RadioListTile(
              title: const Text("Card Payment"),
              value: "Card Payment",
              groupValue: paymentMethod,
              onChanged: (val) {
                setState(() => paymentMethod = val!);
              },
            ),

            const Spacer(),

            // Payment Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  summaryRow("Subtotal", widget.subtotal),
                  summaryRow("Delivery Fee", widget.deliveryFee),
                  summaryRow("Service Fee", widget.serviceFee),
                  const Divider(),
                  summaryRow("Total Amount", totalAmount, bold: true),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // Proceed Order Logic Here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Order placed with $paymentMethod"),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF456B2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Center(
                      child: Text(
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
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            "${value.toStringAsFixed(3)} OMR",
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
